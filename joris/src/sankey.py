import numpy as np
# from numpy.lib.function_base import _diff_dispatcher
import pandas as pd


class Sankey():
    def __init__(self):
        self.sankey_col = ["source", "target", "value"]
        self.df_sankey = pd.DataFrame(columns=self.sankey_col)

    def append_to_df(self, df):
        df.columns = self.sankey_col
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

    @staticmethod
    def make_bins_nb_albums(nb_albums):
        bin_max = 10
        if nb_albums < 10:
            return int(nb_albums)
        else:
            return bin_max

    @staticmethod
    def name_album_bins(nb_albums):
        bin_max = 10
        if nb_albums <= 1:
            return f"{nb_albums} album"
        elif nb_albums < 10:
            return f"{nb_albums} albums"
        else:
            return f"{bin_max}+ albums"

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


class AlbumsAwards():
    def __init__(self, load_data):
        self.load_data = load_data

    @property
    def df_albums(self):
        if hasattr(self, "_df_albums"):
            return self._df_albums
        else:
            df_albums = self.load_data.albums_data.copy()
            df_albums = df_albums.rename(columns={"_id": "id_album"})

            self._df_albums = df_albums
            return df_albums

    @property
    def df_awards(self):
        if hasattr(self, "_df_awards"):
            return self._df_awards
        else:
            df_awards = self.load_data.songs_data.copy()
            df_awards = df_awards[["id_album", "award"]]

            # add ObjectId to cells missing it
            df_awards["id_album"] = [
                element if element.startswith("ObjectId(")
                else "ObjectId("+element
                for element in df_awards["id_album"]]
            df_awards["id_album"] = [
                element if element.endswith(")")
                else element+")"
                for element in df_awards["id_album"]]

            df_awards["award"] = df_awards["award"].apply(self.clean_awards)
            # df_awards = df_awards.groupby(
            #     ["id_album", "award"],
            #     as_index=False).size()
            # df_awards.groupby

            self._df_awards = df_awards
            return df_awards

    @staticmethod
    def clean_awards(award):
        """Replace messy awards string by the highest award won."""

        try:
            if isinstance(award, float) and np.isnan(award):
                return "unknown_award"
            elif isinstance(award, list):
                return len(award)
            elif isinstance(award, str):
                award = award.lower()
                award_names = ["diamond", "platinum", "gold", "silver"]
                for award_name in award_names:
                    if award_name in award:
                        return award_name
                    elif "million" in award:
                        return "platinum"
                    else:
                        return "no_award"
                return award
            else:
                print(award, type(award))
                return award
        except Exception as e:
            print(f"EXCEPTION {e}: {award}, {type(award)}")
