import pandas as pd


class LoadData():
    # get unique values of columns needed
    albums_col = ["_id", "id_artist"]
    artists_col = ["_id", "type", "gender", "members"]
    songs_col = ["id_album", "genre"]

    @classmethod
    def load_albums_data(cls):
        try:
            cls.albums_data == None
        except AttributeError:
            cls.albums_data = pd.read_csv(
                "../../data/wasabi_albums.csv", usecols=cls.albums_col)

    @classmethod
    def load_artists_data(cls):
        try:
            cls.artists_data == None
        except AttributeError:
            cls.artists_data = pd.read_csv(
                "../../data/wasabi_artists.csv", usecols=cls.artists_col)

    @classmethod
    def load_songs_data(cls):
        try:
            cls.songs_data == None
        except AttributeError:
            cls.songs_data = pd.read_csv(
                "../../data/wasabi_songs.csv", usecols=cls.songs_col, sep="\t")

    @classmethod
    def load_all_data(cls):
        cls.load_albums_data()
        cls.load_artists_data()
        cls.load_songs_data()
