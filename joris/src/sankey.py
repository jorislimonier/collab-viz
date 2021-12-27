import numpy as np
import pandas as pd


class Sankey():
    def __init__(self):
        self.SANKEY_COL = ["source", "target", "value"]
        self.df_sankey = pd.DataFrame(columns=self.SANKEY_COL)

    def append_to_df(self, df):
        df.columns = self.SANKEY_COL
        self.df_sankey = self.df_sankey.append(df)

    def write_csv(self):
        self.df_sankey.to_csv("../sankey.csv", index=False)


class TypeGender():
    def __init__(self, load_data):
        self.load_data = load_data
        self.df_sankey = self.generate_df_sankey()

    def generate_df_sankey(self):
        df = self.load_data.artists_data
        df = df.copy()
        df = df.groupby(["type", "gender"], dropna=False).count()
        df = df.reset_index()
        df = df.drop(columns=["location", "members"], errors="ignore")
        df = df.rename(columns={"_id": "value"})
        df = df.fillna({col: "unknown_"+col for col in df.columns})
        df = df.replace({col: {"Other": "unknown_"+col for _ in df.columns}
                        for col in df.columns})
        return df


class GenderAlbums():
    def __init__(self, load_data):
        self.load_data = load_data
        self.df_albums = self.generate_df_albums()
        self.df_artists = self.generate_df_artists()
        self.df_sankey = self.generate_df_sankey()

    def generate_df_albums(self):
        df_albums = self.load_data.albums_data.copy()
        df_albums = df_albums.groupby("id_artist").count()
        df_albums = df_albums.rename(columns={"_id": "nb_albums"})
        df_albums = df_albums.reset_index()

        df_albums["id_artist"] = [
            element
            if element.startswith("ObjectId(")
            else "ObjectId("+element+")"
            for element in df_albums["id_artist"]]
        return df_albums

    def generate_df_artists(self):
        df_artists = self.load_data.artists_data.copy()
        df_artists = df_artists.rename(columns={"_id": "id_artist"})
        [["id_artist", "gender"]]
        return df_artists

    def check_no_mismatch(self):
        l1 = np.array(self.df_albums["id_artist"])
        l2 = np.array(self.df_artists["id_artist"])
        assert set(l1).symmetric_difference(set(l2)) == set(), "Mismatch"

    def generate_df_sankey(self):
        self.check_no_mismatch()
        df = self.df_artists.copy()
        df = df.merge(self.df_albums, on="id_artist", how="outer")
        df = df.fillna({col: "unknown_"+col for col in df.columns})
        df = df.replace(
            {col: {"Other": "unknown_"+col for _ in df.columns} for col in df.columns})
        df = df.drop(columns="id_artist")
        df = df.value_counts()
        df = df.reset_index()
        df["nb_albums"] = df["nb_albums"].apply(self.make_bins_nb_albums)
        df = df.groupby(["gender", "nb_albums"])
        df = df.sum()
        df = df.reset_index()
        df = df.sort_values("nb_albums")
        df["nb_albums"] = df["nb_albums"].apply(self.name_album_bins)
        return df

    @staticmethod
    def make_bins_nb_albums(nb_albums):
        bin_max = 10
        if nb_albums < bin_max:
            return int(nb_albums)
        else:
            return bin_max

    @staticmethod
    def name_album_bins(nb_albums):
        bin_max = 10
        if nb_albums <= 1:
            return f"{nb_albums} album"
        elif nb_albums < bin_max:
            return f"{nb_albums} albums"
        else:
            return f"{bin_max}+ albums"


class AlbumsSongs():
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
                for element in df_albums["id_artist"]]
            df_albums["id_artist"] = [
                element
                if element.endswith(")")
                else element + ")"
                for element in df_albums["id_artist"]]

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
                for element in df_songs["id_album"]]
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
            df_sankey["nb_songs"] = df_sankey["nb_songs"].astype(int)

            nb_albums = df_sankey.groupby("id_artist").size()
            df_sankey["nb_albums"] = nb_albums[df_sankey["id_artist"]].values
            df_sankey = df_sankey.groupby("id_artist").mean()
            df_sankey = df_sankey.reset_index(drop=True)
            df_sankey["nb_albums"] = df_sankey["nb_albums"].astype(int)
            df_sankey = df_sankey.rename(
                columns={"nb_songs": "av_songs_per_album"})
            df_sankey["nb_albums"] = df_sankey["nb_albums"].apply(
                GenderAlbums.make_bins_nb_albums)
            df_sankey["nb_albums"] = df_sankey["nb_albums"].apply(
                GenderAlbums.name_album_bins)
            df_sankey["av_songs_per_album"] = df_sankey["av_songs_per_album"].apply(self.make_bins_av_songs_per_album)
            df_sankey = df_sankey[["nb_albums", "av_songs_per_album"]]
            df_sankey = df_sankey.groupby(
                ["nb_albums", "av_songs_per_album"], as_index=False).size()

            self._df_sankey = df_sankey

        return self._df_sankey

    @staticmethod
    def make_bins_av_songs_per_album(nb_songs):
        bin_max = 20
        if nb_songs < 10:
            return np.round(nb_songs, decimals=0).astype(int)
        elif nb_songs < bin_max:
            return np.round(nb_songs, decimals=-1).astype(int)
        else:
            return bin_max+1
