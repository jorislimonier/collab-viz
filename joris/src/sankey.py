import numpy as np
import pandas as pd
import json


class Sankey():
    SANKEY_COL = ["source", "target", "value"]
    PATH_SANKEY_DATA = "../data-sankey/"
    PATH_SANKEY_FINAL_FILE = "../sankey.csv"

    @property
    def df_sankey(self):
        df_sankey = pd.DataFrame(columns=self.SANKEY_COL)
        file_names = [
            my_class.FILENAME for my_class in [TypeGender, GenderAlbums, AlbumsSongs]
        ]
        for file_name in file_names:
            df = pd.read_csv(self.PATH_SANKEY_DATA+file_name+".csv")
            df_sankey = df_sankey.append(df, ignore_index=True)

        return df_sankey

    @classmethod
    def write_data(
            cls,
            df,
            filename,
            extension="csv",
            columns=None):

        # Allow for optional `columns` argument
        if columns is None:
            df.columns = cls.SANKEY_COL  # `cls` not accessible as a default argument
        else:
            df.columns = columns

        file_path = f"{cls.PATH_SANKEY_DATA}{filename}.{extension}"
        if extension == "json":
            df.to_json(
                path_or_buf=file_path,
                orient="records",
                indent=4
            )
        elif extension == "csv":
            df.to_csv(
                path_or_buf=file_path,
                index=False
            )

    def write_final_data(self):
        """
        Write the data in the correct format to be passed to d3.\\
        The data is written in JSON.
        """

        df_sankey = self.df_sankey.copy()

        # Make "nodes"-part of the JSON file
        node_names = np.concatenate(
            [df_sankey["source"],
             df_sankey["target"]]
        )
        node_names = pd.unique(node_names)
        df_nodes = pd.DataFrame(enumerate(node_names))
        df_nodes.columns = ["node", "name"]

        # Make JSON file for nodes
        json_nodes = df_nodes.to_json(orient="records")
        json_nodes = json.loads(json_nodes)

        # Make "links"-part of the JSON file
        # Replace node names by their index (following d3 Sankey with JSON requirements)
        df_links = df_sankey.copy()
        for col in ["source", "target"]:
            df_links[col] = df_links[col].apply(
                lambda x: int(np.where(node_names == x)[0])
            )

        json_links = df_links.to_json(orient="records")
        json_links = json.loads(json_links)

        # Combine nodes and links
        sankey_json = {
            "nodes": json_nodes,
            "links": json_links
        }

        # Write to file
        with open("../sankey-genre.json", "w") as outfile:
            json.dump(sankey_json, outfile, indent=2)


class TypeGender():
    FILENAME = "type-gender"

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_sankey(self):
        if not hasattr(self, "_df_sankey"):
            df = self.load_data.artists_data
            df = df.copy()
            df = df.groupby(["type", "gender"], dropna=False).count()
            df = df.reset_index()
            df = df.drop(
                columns=["location", "members"],
                errors="ignore"
            )
            df = df.rename(columns={"_id": "value"})
            df = df.fillna({col: "unknown_"+col for col in df.columns})
            df = df.replace(
                {col: {"Other": "unknown_"+col for _ in df.columns}
                 for col in df.columns}
            )

            self._df_sankey = df
        return self._df_sankey

    def write_data(self):
        Sankey.write_data(
            df=self.df_sankey,
            filename=self.FILENAME
        )


class GenderAlbums():
    FILENAME = "gender-albums"

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_albums(self):
        if not hasattr(self, "_df_albums"):
            df_albums = self.load_data.albums_data.copy()
            df_albums = df_albums[["_id", "id_artist", "genre"]]
            df_albums["id_artist"] = df_albums["id_artist"].apply(
                self.fix_id_format)
            df_albums["_id"] = df_albums["_id"].apply(self.fix_id_format)
            df_albums = df_albums.groupby(
                by=["id_artist", "genre"],
                dropna=False,
                as_index=False)
            df_albums = df_albums.count()
            df_albums = df_albums.rename(columns={"_id": "nb_albums"})

            self._df_albums = df_albums
        return self._df_albums

    @staticmethod
    def fix_id_format(id_val):
        """
        Ensure an id is wrapped in `ObjectId(<id>)`
        """
        if not id_val.startswith("ObjectId("):
            id_val = "ObjectId(" + id_val
        if not id_val.endswith(")"):
            id_val = id_val + ")"
        return id_val

    @property
    def df_artists(self):
        if not hasattr(self, "_df_artists"):
            df_artists = self.load_data.artists_data.copy()
            df_artists = df_artists.rename(columns={"_id": "id_artist"})
            [["id_artist", "gender"]]

            self._df_artists = df_artists

        return self._df_artists

    def check_no_mismatch(self):
        l1 = np.array(self.df_albums["id_artist"])
        l2 = np.array(self.df_artists["id_artist"])
        assert set(l1).symmetric_difference(set(l2)) == set(), "Mismatch"

    @property
    def df_sankey(self):
        if not hasattr(self, "_df_sankey"):
            self.check_no_mismatch()
            df = self.df_artists[["id_artist", "gender"]].copy()
            df = df.merge(
                self.df_albums,
                on="id_artist",
                how="outer"
            )
            df = df.fillna({col: "unknown_"+col for col in df.columns})
            df = df.replace(
                {col: {"Other": "unknown_"+col for _ in df.columns}
                 for col in df.columns}
            )
            df = df.drop(columns=["id_artist"])
            df["nb_albums"] = self.make_bins_albums(df["nb_albums"])
            df = df.groupby(
                by=["gender", "nb_albums", "genre"],
                as_index=False,
            ).size()
            df = df[df["size"] != 0]

            # Reorder columns to put genre last
            new_cols = [
                col for col in df.columns.tolist()
                if col != "genre"
            ] + ["genre"]
            df = df[new_cols]

            self._df_sankey = df
        return self._df_sankey

    @staticmethod
    def make_bins_albums(nb_albums):
        """
        Use pandas' cut function to make bins on the number of albums
        """
        bin_max = 12
        bin_size = 2
        bins = [*range(1, bin_max, bin_size)] + [np.inf]
        labels = []
        for i, edge in enumerate(bins[:-1]):
            next_edge = bins[i+1]-1
            if next_edge == np.inf:
                labels.append(f">{edge-1} albums")
                continue
            labels.append(f"{edge}-{next_edge} albums")
        return pd.cut(nb_albums, bins, include_lowest=True, labels=labels)

    def write_data(self):
        Sankey.write_data(
            df=self.df_sankey,
            filename=self.FILENAME,
            columns=Sankey.SANKEY_COL+["genre"]
        )


class AlbumsSongs():
    FILENAME = "albums-songs"

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_albums(self):
        if not hasattr(self, "_df_albums"):
            df_albums = self.load_data.albums_data.copy()
            df_albums = df_albums.rename(columns={"_id": "id_album"})
            df_albums = df_albums[["id_artist", "id_album"]]

            df_albums["id_artist"] = [
                element
                if element.startswith("ObjectId(")
                else "ObjectId(" + element
                for element in df_albums["id_artist"]
            ]
            df_albums["id_artist"] = [
                element
                if element.endswith(")")
                else element + ")"
                for element in df_albums["id_artist"]
            ]

            self._df_albums = df_albums

        return self._df_albums

    @property
    def df_songs(self):
        if not hasattr(self, "_df_songs"):
            df_songs = self.load_data.songs_data.copy()
            df_songs = df_songs[["id_album"]]
            df_songs["id_album"] = [
                element
                if element.startswith("ObjectId(")
                else "ObjectId("+element+")"
                for element in df_songs["id_album"]
            ]
            df_songs = df_songs.groupby("id_album", as_index=False).size()
            df_songs = df_songs.rename(columns={"size": "nb_songs"})

            self._df_songs = df_songs

        return self._df_songs

    @property
    def df_sankey(self):
        if not hasattr(self, "_df_sankey"):
            df_albums = self.df_albums.copy()
            df_songs = self.df_songs.copy()
            df_sankey = df_albums.merge(
                df_songs,
                on="id_album",
                how="outer"
            )
            df_sankey["nb_songs"] = df_sankey["nb_songs"].fillna(0)
            df_sankey["nb_songs"] = df_sankey["nb_songs"].astype(int)

            nb_albums = df_sankey.groupby("id_artist").size()
            df_sankey["nb_albums"] = nb_albums[df_sankey["id_artist"]].values
            df_sankey = df_sankey.groupby("id_artist").mean()
            df_sankey = df_sankey.reset_index(drop=True)
            df_sankey["nb_albums"] = df_sankey["nb_albums"].astype(int)
            df_sankey = df_sankey.rename(
                columns={"nb_songs": "av_songs_per_album"}
            )
            df_sankey["nb_albums"] = GenderAlbums.make_bins_albums(
                df_sankey["nb_albums"]
            )

            df_sankey["av_songs_per_album"] = self.make_bins_av_songs_per_album(
                df_sankey["av_songs_per_album"]
            )
            df_sankey = df_sankey[["nb_albums", "av_songs_per_album"]]
            df_sankey = df_sankey.groupby(
                ["nb_albums", "av_songs_per_album"],
                as_index=False
            ).size()

            self._df_sankey = df_sankey

        return self._df_sankey

    @staticmethod
    def make_bins_av_songs_per_album(nb_songs):
        """
        Use pandas' cut function to make bins on the number average number of songs per albums
        """
        bin_max = 17
        bin_size = 3
        bins = [*range(1, bin_max, bin_size)] + [np.inf]
        labels = []

        for i, edge in enumerate(bins[:-1]):
            next_edge = bins[i+1]-1
            if next_edge == np.inf:
                labels.append(f">{edge-1} songs/album")
                continue
            labels.append(f"{edge}-{next_edge} songs/album")

        return pd.cut(nb_songs, bins, include_lowest=True, labels=labels)

    def write_data(self):
        Sankey.write_data(
            df=self.df_sankey,
            filename=self.FILENAME
        )
