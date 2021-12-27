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

# %% [markdown]
# # Type $\to$ gender

# %%
type_gender = sk.TypeGender(load_data)
sankey_diag.append_to_df(type_gender.df_sankey)

# %% [markdown]
# # Gender $\to$ nb_albums

# %%
gender_nb_albums = sk.GenderAlbums(load_data)
sankey_diag.append_to_df(gender_nb_albums.df_sankey)


# %%
sankey_diag.write_csv()
sankey_diag.df_sankey

# %% [markdown]
# # Nb albums $\to$ Average awards per album

# %%

reload()
albums_songs = sk.AlbumsSongs(load_data)


albums_songs.df_songs.groupby("id_album").size()
# %%