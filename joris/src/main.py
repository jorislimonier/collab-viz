# %%
import pandas as pd
import numpy as np
import load_data as ld
import sankey as sk
import importlib


def reload():
    importlib.reload(ld)
    importlib.reload(sk)

# %% [markdown]
# # Initialize `LoadData` and `Sankey` classes


# %%
reload()
load_data = ld.LoadData()
sankey_diag = sk.Sankey()

# %%
# %% [markdown]
# # Type $\to$ gender

# %%
reload()
type_gender = sk.TypeGender(load_data)
# type_gender.write_data()
type_gender.df_sankey["value"].sum()


# %%
load_data.artists_data
# %% [markdown]
# # Gender $\to$ nb_albums

# %%
reload()
gender_albums = sk.GenderAlbums(load_data)
# gender_albums.write_data()
df = gender_albums.df_sankey
df
# %%
# pd.merge(left=df, right=maj_genre, on="id_artist", how="right")
# %%
reload()
gender_albums = sk.GenderAlbums(load_data)
df = gender_albums.df_sankey
gender_albums.write_data()
df


# %% [markdown]
# # Nb albums $\to$ Average awards per album

# %%
reload()
albums_songs = sk.AlbumsSongs(load_data)
df_sankey = albums_songs.df_sankey
albums_songs.write_data()
df_sankey
# %%
nb_albums = df_sankey.groupby(
    by=["id_artist"],
    as_index=False,
).size()
maj_genre = df_sankey.groupby(by=["id_artist"])["genre"].agg(pd.Series.mode)
maj_genre = maj_genre.apply(
    lambda genre: genre if isinstance(genre, str) else genre[0]
)
# %%
display(df_sankey)
display(maj_genre)
df_sankey["genre"] = maj_genre[df_sankey["id_artist"]].values
display(df_sankey)

display(nb_albums)

# %%
reload()
sankey_diag = sk.Sankey()
sankey_diag.write_final_data()
sankey_diag.df_sankey["genre"].value_counts()

# %%
