library(data.table)

cem_col = list("albums"= c(),
           "artists"= c(),
           "songs"= c())
joris_col = list("albums"= c("_id", "id_artist"),
             "artists"= c("_id", "type", "gender", "members"),
             "songs"= c("id_album", "genre"))
marlize_col = list("albums"= c("_id", "id_artist", "genre", "publicationDate"),
               "artists"= c("_id", "location"),
               "songs"= c("id_album", "award"))

albums_col <- c()
artists_col <- c()
songs_col <- c()

for (person_col in list(cem_col, marlize_col, joris_col)){
    albums_col <- unique(append(albums_col, person_col$albums))
    artists_col <- unique(append(artists_col, person_col$artists))
    songs_col <- unique(append(songs_col, person_col$songs))
}

albums_data <- fread("wasabi_albums.csv/wasabi_albums.csv", select=albums_col)
artists_data <- fread("wasabi_artists.csv/wasabi_artists.csv", select=artists_col)
songs_data <- fread("wasabi_songs.csv/wasabi_songs.csv", select=songs_col, sep="\t")

head(albums_data)
head(artists_data)
head(songs_data)