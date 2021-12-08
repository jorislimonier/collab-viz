# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import pandas as pd
import numpy as np
import load_data as ld
import sankey as sk

import importlib
importlib.reload(sk)
importlib.reload(ld)


# %%
# try:
#     display(LoadData.albums_data.head(2))
# except AttributeError:
#     LoadData.load_albums_data()
#     display(LoadData.albums_data.head(2))

# try:
#     display(LoadData.artists_data.head(2))
# except AttributeError:
#     LoadData.load_artists_data()
#     display(LoadData.artists_data.head(2))

# try:
#     display(LoadData.songs_data.head(2))
# except AttributeError:
#     LoadData.load_songs_data()
#     display(LoadData.songs_data.head(2))

# %% [markdown]
# # Type $\to$ gender

# %%
load_data = ld.LoadData()
sankey_diag = sk.Sankey()
type_gender = sk.TypeGender(load_data)
display(type_gender.df_sankey)
display(sankey_diag.df_sankey)
sankey_diag.append_to_df(type_gender.df_sankey)
display(sankey_diag.df_sankey)

# %% [markdown]
# # Gender $\to$ nb_albums

# %%
# gender_nb_albums.df_albums


# %%
gender_nb_albums = sk.GenderNbAlbums(load_data)
sankey_diag.append_to_df(gender_nb_albums.df_sankey)


# %%
sankey_diag.write_csv()
sankey_diag.df_sankey

# %% [markdown]
# # Nb albums $\to$ nb songs

# %%
df_songs = (songs_data
      .copy()
      [["id_album"]])

# add ObjectIt to cells missing it
df_songs["id_album"] = [element if element.startswith(
    "ObjectId(") else "ObjectId("+element+")" for element in df_songs["id_album"]]
pd.DataFrame(df_songs.value_counts()).reset_index()


