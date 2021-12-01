import pandas as pd


class LoadData():
    def __init__(self):
        # get unique values of columns needed
        self.albums_col = ["_id", "id_artist"]
        self.artists_col = ["_id", "type", "gender", "members"]
        self.songs_col = ["id_album", "genre"]
        self.albums_data = pd.read_csv(
            "./data/wasabi_albums.csv", usecols=self.albums_col)
        self.artists_data = pd.read_csv(
            "./data/wasabi_artists.csv", usecols=self.artists_col)
        self.songs_data = pd.read_csv(
            "./data/wasabi_songs.csv", usecols=self.songs_col, sep="\t")


# ld = LoadData()
# ld.load_datasets()
# print(ld.albums_data)
