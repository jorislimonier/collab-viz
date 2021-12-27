import pandas as pd


class LoadData():
    # get columns needed
    ALBUMS_COL = ["_id", "id_artist"]
    ARTISTS_COL = ["_id", "type", "gender", "members"]
    SONGS_COL = ["id_album", "genre", "award"]
    DATA_BASE_PATH = "../../data/"

    @property
    def albums_data(self):
        """Loads `albums_data` only if needed"""
        if hasattr(self, "_albums_data"):
            return self._albums_data

        else:
            self._albums_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_albums.csv",
                usecols=self.ALBUMS_COL)

            return self._albums_data

    @property
    def artists_data(self):
        """Loads `artists_data` only if needed"""
        if hasattr(self, "_artists_data"):
            return self._artists_data

        else:
            self._artists_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_artists.csv",
                usecols=self.ARTISTS_COL)

            return self._artists_data

    @property
    def songs_data(self):
        """Loads `songs_data` only if needed"""
        if hasattr(self, "_songs_data"):
            return self._songs_data

        else:
            self._songs_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_songs.csv",
                usecols=self.SONGS_COL,
                sep="\t")

            return self._songs_data
