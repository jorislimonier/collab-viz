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
try:
    print(load_data)
except:
    load_data = ld.LoadData()
sankey_diag = sk.Sankey()

# %%
# %% [markdown]
# # Type $\to$ gender

# %%
reload()
type_gender = sk.TypeGender(load_data)
# sankey_diag.append_to_df(type_gender.df_sankey)
type_gender.write_data()
# %% [markdown]
# # Gender $\to$ nb_albums

# %%
reload()
gender_albums = sk.GenderAlbums(load_data)
gender_albums.write_data()

# sankey_diag.append_to_df(gender_albums.df_sankey)

# %% [markdown]
# # Nb albums $\to$ Average awards per album

# %%

reload()
albums_songs = sk.AlbumsSongs(load_data)
albums_songs.write_data()


# %%
# %%
sankey_diag.append_to_df(albums_songs.df_sankey)


# %%
reload()
sankey_diag = sk.Sankey()
sankey_diag.write_final_data()
sankey_diag.df_sankey