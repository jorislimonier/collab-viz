import pandas as pd


class LoadData():
    def __init__(self):
        self.DATA_BASE_PATH = "../../data/"
    # get columns needed
    ALBUMS_COL = ["_id", "id_artist"]
    ARTISTS_COL = ["_id", "type", "gender", "members"]
    SONGS_COL = ["id_album", "genre", "award"]
    DATA_BASE_PATH = "../../data/"

    @property
    def albums_data(self):
        try:
            return self._albums_data
        
        except AttributeError:
            self._albums_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_albums.csv",
                usecols=self.ALBUMS_COL)
            
            return self._albums_data

    @property
    def artists_data(self):
        try:
            return self._artists_data
        
        except AttributeError:
            self._artists_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_artists.csv",
                usecols=self.ARTISTS_COL)
            
            return self._artists_data

    @property
    def songs_data(self):
        try:
            return self._songs_data
        
        except AttributeError:
            self._songs_data = pd.read_csv(
                self.DATA_BASE_PATH + "wasabi_songs.csv",
                usecols=self.SONGS_COL,
                sep="\t")
            
            return self._songs_data
