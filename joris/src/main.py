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
albums_awards.df_awards.loc[albums_awards.df_awards["award"] == "platinum"]
albums_awards.df_awards.iloc[602852:602884]
albums_awards.df_awards.loc[albums_awards.df_awards["id_album"] == "ObjectId(5714debb25ac0d8aee35c37e)"]
# %%
def get_max_award(awards):
    award_names = ["diamond", "platinum", "gold", "silver", "no_award"]
    for award_name in award_names:
        if award_name in awards:
            return award_name
    return "unknown_award"
albums_awards.df_awards.groupby("id_album").apply(lambda x: get_max_award(x["award"])).value_counts() # fix that


# %%
# for e in albums_awards.df_awards.groupby("id_album"):
#     print(e)
# %%
l1 = np.array(albums_awards.df_albums["id_album"])
l2 = np.array(albums_awards.df_awards["id_album"])
set(l2).symmetric_difference(set(l1))

len(albums_awards.df_awards["id_album"].unique()), len(
    albums_awards.df_albums["id_album"].unique()), len(set(l1) ^ set(l2))

# %%
albums_awards.df_awards

# %%


# %%
