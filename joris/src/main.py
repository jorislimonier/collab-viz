# %%
import pandas as pd
import numpy as np
import load_data as ld
import sankey as sk
import importlib

def reload():
    importlib.reload(ld)
    importlib.reload(sk)


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
reload()
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
albums_awards.df_awards["award"].unique()

# %%
[x for x in albums_awards.df_awards["award"] if not pd.isna(x)]
# %%
"abcd la"[::-1].replace("a", "", 1)[::-1]