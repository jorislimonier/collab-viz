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
albums_awards = sk.AlbumsAwards(load_data)

# %%
albums_awards.df_albums
# %%
l1 = np.array(albums_awards.df_albums["id_album"])
l2 = np.array(albums_awards.df_awards["id_album"])
set(l2).symmetric_difference(set(l1))

len(albums_awards.df_awards["id_album"].unique()), len(
    albums_awards.df_albums["id_album"].unique()), len(set(l1) ^ set(l2))

# %%
albums_awards.df_awards
# %%
reload()
# %%
lddt = ld.LoadData()

# %%
lddt.albums_data