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
# gender_albums.write_data()
df


# %%
filt = df[df["id_artist"] == 'ObjectId(56d7e91b6b60c09814f93e4a)']
np.where(filt["nb_albums"] == max(filt["nb_albums"]))[0][0]
filt.mode()



# %% [markdown]
# # Nb albums $\to$ Average awards per album

# %%

reload()
albums_songs = sk.AlbumsSongs(load_data)
albums_songs.df_sankey
albums_songs.write_data()

# %%
reload()
sankey_diag = sk.Sankey()
sankey_diag.write_final_data()
sankey_diag.df_sankey["genre"].value_counts()

# %%
