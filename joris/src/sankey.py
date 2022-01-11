import numpy as np
import pandas as pd
import json


class TypeGender:
    FILENAME = "type-gender"

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_sankey(self):
        if not hasattr(self, "_df_sankey"):
            df = self.load_data.artists_data.copy()
            df = df.fillna({col: "unknown_" + col for col in df.columns})
            df = df.replace(
                {
                    col: {"Other": "unknown_" + col for _ in df.columns}
                    for col in df.columns
                }
            )
            df = df.groupby(
                by=["type", "gender"],
                dropna=False,
                as_index=False,
            ).count()
            df = df.rename(columns={"_id": "value"})

            self._df_sankey = df

        return self._df_sankey

    def write_data(self):
        """
        Write `df_sankey` to `self.FILENAME`
        """
        Sankey.write_data(df=self.df_sankey, filename=self.FILENAME)


class GenderAlbums:
    FILENAME = "gender-albums"
    MAX_ALBUMS_VAL = 10

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_albums(self):
        if not hasattr(self, "_df_albums"):
            df_albums = self.load_data.albums_data.copy()
            df_albums = df_albums[["_id", "id_artist", "genre"]]
            df_albums["id_artist"] = df_albums["id_artist"].apply(self.fix_id_format)
            df_albums["_id"] = df_albums["_id"].apply(self.fix_id_format)
            # df_albums = df_albums.groupby(
            #     by=["id_artist", "genre"],
            #     dropna=False,
            #     as_index=False,
            # ).agg(pd.Series.mode)
            df_albums = df_albums.rename(
                columns={
                    "size": "nb_albums",
                    "_id": "id_album",
                }
            )

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

    @property
    def df_sankey(self):
        if not hasattr(self, "_df_sankey"):
            self.check_no_mismatch()
            df = self.df_artists[["id_artist", "gender"]].copy()
            df = pd.merge(
                left=df,
                right=self.df_albums,
                on="id_artist",
                how="inner",
            )
            df = df.fillna({col: "unknown_" + col for col in df.columns})
            df = df.replace(
                {
                    col: {"Other": "unknown_" + col for _ in df.columns}
                    for col in df.columns
                }
            )
            maj_genre = df.copy().groupby("id_artist")["genre"].agg(pd.Series.mode)
            maj_genre = maj_genre.apply(
                lambda genre: genre if isinstance(genre, str) else genre[0]
            )
            df["genre"] = maj_genre[df["id_artist"]].values
            df = df.drop(columns="id_album", errors="ignore")
            
            df = df.groupby(
                by=["id_artist", "gender", "genre"],
                as_index=False,
            ).size()
            # df["genre"] = maj_genre[df["id_artist"]].values
            df = df.drop(columns=["id_artist"])
            display(df)
            df = df.rename(columns={"size": "nb_albums"})
            df["nb_albums"] = df["nb_albums"].apply(self.format_albums)
            df = df.groupby(
                by=["gender", "nb_albums", "genre"],
                as_index=False,
            ).size()
            
            # Reorder columns to put genre last
            new_cols = [col for col in df.columns.tolist() if col != "genre"] + [
                "genre"
            ]
            df = df[new_cols]

            self._df_sankey = df
            # return df

            # display(df.groupby("id_artist", as_index=False).size())


        return self._df_sankey

    def check_no_mismatch(self):
        l1 = np.array(self.df_albums["id_artist"])
        l2 = np.array(self.df_artists["id_artist"])
        assert set(l1).symmetric_difference(set(l2)) == set(), "Mismatch"

    @staticmethod
    def format_albums(nb_albums):
        """
        Format the number of albums
        """
        if nb_albums == 1:
            return f"{nb_albums} album"
        elif nb_albums < GenderAlbums.MAX_ALBUMS_VAL:
            return f"{nb_albums} albums"
        else:
            return f"{GenderAlbums.MAX_ALBUMS_VAL}+ albums"

    def write_data(self):
        """
        Write `df_sankey` to `self.FILENAME`
        """
        Sankey.write_data(
            df=self.df_sankey,
            filename=self.FILENAME,
            columns=Sankey.SANKEY_COL + ["genre"],
        )


class AlbumsSongs:
    FILENAME = "albums-songs"
    MAX_SONGS_VAL = 15

    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_albums(self):
        if not hasattr(self, "_df_albums"):
            df_albums = self.load_data.albums_data.copy()
            df_albums = df_albums.rename(columns={"_id": "id_album"})
            df_albums = df_albums[["id_artist", "id_album", "genre"]]

            df_albums["id_artist"] = [
                element if element.startswith("ObjectId(") else "ObjectId(" + element
                for element in df_albums["id_artist"]
            ]
            df_albums["id_artist"] = [
                element if element.endswith(")") else element + ")"
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
                else "ObjectId(" + element + ")"
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
            df_sankey = df_albums.merge(df_songs, on="id_album", how="outer")
            df_sankey["nb_songs"] = df_sankey["nb_songs"].fillna(0)
            df_sankey["genre"] = df_sankey["genre"].fillna("unkown_genre")
            df_sankey["nb_songs"] = df_sankey["nb_songs"].astype(int)

            nb_albums = df_sankey.groupby(["id_artist", "genre"], as_index=False).size()
            df_sankey = pd.merge(
                left=df_sankey,
                right=nb_albums,
                how="inner",
                on=["id_artist", "genre"],
            )
            df_sankey = df_sankey.groupby(
                by=["id_artist", "genre"],
                as_index=False,
            ).mean()
            df_sankey = df_sankey.rename(
                columns={"nb_songs": "av_songs_per_album", "size": "nb_albums"}
            )
            df_sankey = df_sankey.drop(columns=["id_artist"])
            df_sankey["nb_albums"] = df_sankey["nb_albums"].astype(int)
            df_sankey["nb_albums"] = df_sankey["nb_albums"].apply(
                GenderAlbums.format_albums
            )
            df_sankey["av_songs_per_album"] = df_sankey["av_songs_per_album"].apply(
                self.format_songs_per_album
            )
            df_sankey = df_sankey.groupby(
                by=[
                    "nb_albums",
                    "av_songs_per_album",
                    "genre",
                ],
                as_index=False,
            ).size()
            df_sankey = df_sankey[df_sankey["size"] != 0]
            df_sankey = df_sankey[["nb_albums", "av_songs_per_album", "size", "genre"]]

            self._df_sankey = df_sankey

        return self._df_sankey

    @staticmethod
    def format_songs_per_album(nb_songs):
        """
        Format the average number of songs per albums
        """
        nb_songs = int(nb_songs)
        if nb_songs == 1:
            return f"{nb_songs} song/album"
        elif nb_songs < AlbumsSongs.MAX_SONGS_VAL:
            return f"{nb_songs} songs/album"
        else:
            return f"{AlbumsSongs.MAX_SONGS_VAL}+ songs/album"

    def write_data(self):
        """
        Write `df_sankey` to `self.FILENAME`
        """
        Sankey.write_data(
            df=self.df_sankey,
            filename=self.FILENAME,
            columns=Sankey.SANKEY_COL + ["genre"],
        )


class Sankey:
    SANKEY_COL = [
        "source",
        "target",
        "value",
    ]
    PATH_SANKEY_DATA = "../data-sankey/"
    PATH_SANKEY_FINAL_FILE = "../sankey.csv"

    # Custom value orders
    TYPE_VALUES_ORDERED = [
        "Person",
        "Character",
        "Choir",
        "Group",
        "Orchestra",
        "unknown_type",
    ]
    GENDER_VALUES_ORDERED = [
        "Male",
        "Female",
        "unknown_gender",
    ]
    ALBUMS_VALUES_ORDERED = [
        GenderAlbums.format_albums(val + 1)
        for val in range(GenderAlbums.MAX_ALBUMS_VAL)
    ]
    SONGS_VALUES_ORDERED = [
        AlbumsSongs.format_songs_per_album(val + 1)
        for val in range(AlbumsSongs.MAX_SONGS_VAL)
    ]

    @property
    def df_sankey(self):
        df_sankey = pd.DataFrame(columns=self.SANKEY_COL)
        file_names = [
            my_class.FILENAME for my_class in [TypeGender, GenderAlbums, AlbumsSongs]
        ]
        for file_name in file_names:
            df = pd.read_csv(self.PATH_SANKEY_DATA + file_name + ".csv")
            df_sankey = df_sankey.append(df, ignore_index=True)

        with open(self.PATH_SANKEY_DATA + "/replace-genres.json") as replace_json:
            replace_json = json.load(replace_json)
            df_sankey["genre"] = df_sankey["genre"].apply(
                func=self.group_genres,
                grouping_json=replace_json,
            )

        df_sankey = df_sankey.groupby(
            by=["source", "target", "genre"],
            as_index=False,
            dropna=False,
        ).sum()

        # Make custom values order
        VALUES_ORDERED = np.concatenate(
            [
                Sankey.TYPE_VALUES_ORDERED,
                Sankey.GENDER_VALUES_ORDERED,
                Sankey.ALBUMS_VALUES_ORDERED,
                Sankey.SONGS_VALUES_ORDERED,
            ]
        )

        df_sankey["source"] = pd.Categorical(
            values=df_sankey["source"],
            categories=VALUES_ORDERED,
            ordered=True,
        )
        df_sankey["target"] = pd.Categorical(
            values=df_sankey["target"],
            categories=VALUES_ORDERED,
            ordered=True,
        )
        df_sankey = df_sankey.sort_values(
            by=["source", "target"],
            ignore_index=True,
        )

        return df_sankey

    @staticmethod
    def group_genres(genre, grouping_json):
        """
        Make custom genre grouping from json file
        """
        if isinstance(genre, str):
            if genre == "unknown_genre":  # not to mess with unknown genres
                return genre
            # get general group and all patterns to check
            for group, patterns in grouping_json.items():
                for pattern in patterns:
                    if pattern in genre.lower():
                        return group
        return "unknown_genre"

    @classmethod
    def write_data(cls, df, filename, extension="csv", columns=None):

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
                indent=4,
            )
        elif extension == "csv":
            df.to_csv(
                path_or_buf=file_path,
                index=False,
            )

    def write_final_data(self):
        """
        Write the data in the correct format to be passed to d3.\\
        The data is written in JSON.
        """

        df_sankey = self.df_sankey.copy()

        # Make "nodes"-part of the JSON file
        node_names = np.concatenate(
            [
                df_sankey["source"],
                df_sankey["target"],
            ]
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
                lambda x: int(np.where(node_names == x)[0][0])
            )

        json_links = df_links.to_json(orient="records")
        json_links = json.loads(json_links)

        # Combine nodes and links
        sankey_json = {"nodes": json_nodes, "links": json_links}

        # Write to file
        with open("../sankey-genre.json", "w") as outfile:
            json.dump(sankey_json, outfile, indent=2)
