library(data.table)

albums_data <- fread("wasabi_albums.csv/wasabi_albums.csv", select=c("_id"))
artists_data <- fread("wasabi_artists.csv/wasabi_artists.csv", select=c("_id"))
songs_data <- fread("wasabi_songs.csv/wasabi_songs.csv", select=c("id_album"), sep="\t")

head(albums_data)
head(artists_data)
head(songs_data)
