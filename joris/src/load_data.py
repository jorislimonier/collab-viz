import pandas as pd
import functools  # useful for `cached_property`


class LoadData():
    # get unique values of columns needed
    albums_col = ["_id", "id_artist"]
    artists_col = ["_id", "type", "gender", "members"]
    songs_col = ["id_album", "genre"]

    @functools.cached_property
    def albums_data(self):
        return pd.read_csv(
            "/data/wasabi_albums.csv", usecols=self.albums_col)

    @functools.cached_property
    def artists_data(self):
        return pd.read_csv(
            "/data/wasabi_artists.csv", usecols=self.artists_col)

    @functools.cached_property
    def songs_data(self):
        return pd.read_csv(
            "/data/wasabi_songs.csv", usecols=self.songs_col, sep="\t")

