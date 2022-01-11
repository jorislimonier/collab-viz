rm(list = ls())
# Make sure that you set your working directory. It is assumed that the wasabi data is inside the ./Data folder.
setwd("~/Marlize/2021/Frankryk/Klasse/Data Visualisation/Project/Marlize")

library(data.table)

# creating a list of columns that need to be extracted for the wasabi datasets
marlize_col = list("albums"= c("_id", "id_artist", "genre", "publicationDate"),
                   "artists"= c("_id", "location"),
                   "songs"= c("id_album", "award"))

albums_col <- c()
artists_col <- c()
songs_col <- c()

for (person_col in marlize_col){
  albums_col <- unique(append(albums_col, person_col$albums))
  artists_col <- unique(append(artists_col, person_col$artists))
  songs_col <- unique(append(songs_col, person_col$songs))
}

# reading in the wasabi data
albums_data <- fread("./Data/wasabi_albums.csv", select=albums_col)
artists_data <- fread("./Data/wasabi_artists.csv", select=artists_col)
songs_data <- fread("./Data/wasabi_songs.csv", select=songs_col, sep="\t")

# writing new datasets so that the whole wasabi dataset does not need to be loaded each time.
write.csv(albums_data, file = "./Data_for_cleaning/albums_cols.csv")
write.csv(artists_data, file = "./Data_for_cleaning/artists_cols.csv")
write.csv(songs_data, file = "./Data_for_cleaning/songs_cols.csv")

# creating data frames to work with
artists <- read.csv(file = "./Data_for_cleaning/artists_cols.csv")
albums <- read.csv(file = "./Data_for_cleaning/albums_cols.csv")
songs <- read.csv(file = "./Data_for_cleaning/songs_cols.csv")

# join artist's location to album using artist id, and identify if songs in an album received an award and add to
# album based on album id in a new variable "Award"

### CLEANING THE ALBUM DATA ###

# remove first col - no value
albums <- albums[,-1]

# cleaning the album id and artist id columns - removing the "object()" part around the actual id
albums[,1] <- as.character(albums[,1]) # make character to do string comprehension
albums[,2] <- as.character(albums[,2]) # make character to do string comprehension
for (i in 1:nrow(albums)) {
  if (grepl("(", albums[i,1], fixed = TRUE)) { # not all fields contain the "object()"
    albums[i,1] <- unlist(strsplit(albums[i,1], split='(', fixed=TRUE))[2] # remove "object("
    albums[i,1] <- unlist(strsplit(albums[i,1], split=')', fixed=TRUE))[1] # remove ")"
  }
  if (grepl("(", albums[i,2], fixed = TRUE)) { # not all fields contain the "object()"
    albums[i,2] <- unlist(strsplit(albums[i,2], split='(', fixed=TRUE))[2] # remove "object("
    albums[i,2] <- unlist(strsplit(albums[i,2], split=')', fixed=TRUE))[1] # remove ")"
  }
}

albums_1 <- albums # save the cleaned columns to a new dataframe - took long, just to save time if I make mistakes
                   # further down in my code.

# Adding "unknown" to empty genre and publication date columns
albums_1[,3] <- as.character(albums_1[,3]) # make character to do string comprehension
albums_1[,4] <- as.character(albums_1[,4]) # make character to do string comprehension
for (i in 1:nrow(albums_1)) {
  if (albums_1[i,3] == "") {
    albums_1[i,3] = "Unknown"
  }
  if (albums_1[i,3] == "R&amp;B") {
    albums_1[i,3] = "R&B"
  }
  if (albums_1[i,3] == "Ax&#xE9;" | albums_1[i,3] == "43:40") {
    albums_1[i,3] = "Unknown"
  }
  if (albums_1[i,3] == "Forr&#xF3;" ) {
    albums_1[i,3] = "Forro"
  }
  if (albums_1[i,3] == "Neue Deutsche H&#xE4;rte") {
    albums_1[i,3] = "Neue Deutsche Harte"
  }
  if (albums_1[i,3] == "Rock &apos;N&apos; Roll") {
    albums_1[i,3] = "Rock & Roll"
  }
  if (albums_1[i,3] == "Contemporary R&amp;B") {
    albums_1[i,3] = "Contemporary R&B"
  }
  if (albums_1[i,3] == "Rock &apos;N&apos; Roll&#x200E;") {
    albums_1[i,3] = "Rock & Roll"
  }
  if (albums_1[i,3] == "Norte&#xF1;o&#x200E;") {
    albums_1[i,3] = "Norteno"
  }
  if (albums_1[i,3] == "Children&apos;s Music&#x200E;") {
    albums_1[i,3] = "Children's Music"
  }
  if (albums_1[i,3] == "Norte&#xF1;o") {
    albums_1[i,3] = "Norteno"
  }
  if (albums_1[i,3] == "Rock en Espa&#xF1;ol") {
    albums_1[i,3] = "Rock en Espanol"
  }
  if (albums_1[i,3] == "Samba-Can&#xE7;&#xE3;o") {
    albums_1[i,3] = "Samba Cancao"
  }
  if (albums_1[i,3] == "Y&#xE9;-y&#xE9;") {
    albums_1[i,3] = "Ye-ye"
  }
  if (albums_1[i,3] == "Bai&#xE3;o") {
    albums_1[i,3] = "Baiao"
  }
  if (albums_1[i,3] == "Volkst&#xFC;mlich") {
    albums_1[i,3] = "Volkstumlich"
  }
  if (albums_1[i,3] == "Death &apos;n&apos; Roll") {
    albums_1[i,3] = "Death & Roll"
  }
  if (albums_1[i,3] == "M&#xFA;sica Popular Portuguesa") {
    albums_1[i,3] = "Musica Popular Portuguesa"
  }
  
  if (grepl("&#x200E;", albums_1[i,3], fixed = TRUE) | grepl("&#x200F;", albums_1[i,3], fixed = TRUE)) { 
    albums_1[i,3] <-  unlist(strsplit(albums_1[i,3], split='&', fixed=TRUE))[1]
  }
  
  
  if (length(albums_1[i,4]) > 4) { # some publication dates have words in
    albums_1[i,4] <-  unlist(strsplit(albums_1[i,4], split=')', fixed=TRUE))[1]
  }
  if (albums_1[i,4] == "") { # if no publication date -> unknown
    albums_1[i,4] = "Unknown"
  }
  if (grepl("?", albums_1[i,4], fixed = TRUE)) { # if ? in publication date -> unknown
    albums_1[i,4] = "Unknown"
  }
}

# check for N/A's
table(is.na(albums_1$X_id))
table(is.na(albums_1$id_artist))
table(is.na(albums_1$genre))
table(is.na(albums_1$publicationDate))

str(albums_1)

unique(albums_1$genre)

marlize_dataset <- albums_1 # this will become the final dataset

### CLEANING THE ARTISTS DATA ###
cities <- read.csv("./Data_for_cleaning/worldcities.csv")

# a list of countries that will be used to identify if the "Country" entry is actually a country because some are cities.
# "Unknown" was added because entries without a country will be classified as unknown.
countries <- c("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia",
               "Australia", "Austria", "Azerbaijan", "The Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus",
               "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil",
               "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada",
               "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros",
               "Democratic Republic of the Congo", "Republic of the Congo", "Costa Rica", "Côte d'Ivoire", "Croatia",
               "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor",
               "Timor-Leste", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini",
               "Ethiopia", "Fiji", "Finland", "France", "Gabon", "The Gambia", "Georgia", "Germany", "Ghana", "Greece",
               "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", 
               "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan",
               "Kazakhstan", "Kenya", "Kiribati", "North Korea", "South Korea", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos",
               "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", 
               "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania",
               "Mauritius", "Mexico", "Federated States of Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro",
               "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua",
               "Niger", "Nigeria", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea",
               "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda",
               "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino",
               "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
               "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain", "Sri Lanka", "Sudan",
               "South Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand",
               "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine",
               "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City",
               "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe", "Unknown")

# List of the states in the USA, since some countries or cities were actualle states
states <- c('Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida',
            'Georgia',  'Hawaii',  'Idaho',  'Illinois', 'Indiana',  'Iowa',  'Kansas',  'Kentucky',  'Louisiana',  'Maine',
            'Maryland',  'Massachusetts',  'Michigan',  'Minnesota',  'Mississippi',  'Missouri',  'Montana', 'Nebraska',  'Nevada',
            'New Hampshire',  'New Jersey',  'New Mexico',  'New York',  'North Carolina',  'North Dakota',  'Ohio',  'Oklahoma',
            'Oregon',  'Pennsylvania', 'Rhode Island',  'South Carolina',  'South Dakota',  'Tennessee',  'Texas',  'Utah',
            'Vermont',  'Virginia',  'Washington',  'West Virginia',  'Wisconsin',  'Wyoming')


### CLEANING THE ARTISTS DATA ###
artists <- artists[,c(2,3)] # selecting only the album id and location columns

cities <- cities[,c(1,5)] # selecting only the city and country columns

cities$city <- as.character(cities$city) # make character to do string comprehension
cities$country <- as.character(cities$country) # make character to do string comprehension

# adding the cities that were in the WASABI dataset but not in the cities dataset
cities[nrow(cities) + 1, ] <- c("Wien", "Austria")
cities[nrow(cities) + 1, ] <- c("Bahamas", "The Bahamas")
cities[nrow(cities) + 1, ] <- c("Montreal", "Canada")
cities[nrow(cities) + 1, ] <- c("Scotland", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Bayern", "Germany")
cities[nrow(cities) + 1, ] <- c("Prince Edward Island", "Canada")
cities[nrow(cities) + 1, ] <- c("Quebec", "Canada")
cities[nrow(cities) + 1, ] <- c("JonquiÃ¨re", "Canada")
cities[nrow(cities) + 1, ] <- c("Montserrat", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Frankfurt am Main", "Germany")
cities[nrow(cities) + 1, ] <- c("Offenbach am Main", "Germany")
cities[nrow(cities) + 1, ] <- c("Osaka", "Japan")
cities[nrow(cities) + 1, ] <- c("Kyoto", "Japan")
cities[nrow(cities) + 1, ] <- c("Maui County", "United States")
cities[nrow(cities) + 1, ] <- c("PaÃ?s Vasco", "Spain")
cities[nrow(cities) + 1, ] <- c("GuipÃºzcoa", "Spain")
cities[nrow(cities) + 1, ] <- c("Ciudad de MÃ©xico", "Mexico")
cities[nrow(cities) + 1, ] <- c("East Germany", "Germany")
cities[nrow(cities) + 1, ] <- c("Noord-Brabant", "Netherlands")
cities[nrow(cities) + 1, ] <- c("MichoacÃ¡n", "Mexico")
cities[nrow(cities) + 1, ] <- c("Cheshire East", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Gedding", "United States")
cities[nrow(cities) + 1, ] <- c("Lewisham", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Val-d'Or", "Canada")
cities[nrow(cities) + 1, ] <- c("Nelson City", "New Zealand")
cities[nrow(cities) + 1, ] <- c("Northern Ireland", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("RegiÃ³n Metropolitana de Santiago", "Chile")
cities[nrow(cities) + 1, ] <- c("Zurich", "Switzerland")
cities[nrow(cities) + 1, ] <- c("England", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Camberwell", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("The Bronx", "United States")
cities[nrow(cities) + 1, ] <- c("La Habana", "Cuba")
cities[nrow(cities) + 1, ] <- c("Landsberg am Lech", "Germany")
cities[nrow(cities) + 1, ] <- c("Bergen auf RÃ¼gen", "Germany")
cities[nrow(cities) + 1, ] <- c("Netherlands Antilles", "Netherlands")
cities[nrow(cities) + 1, ] <- c("CuraÃ§ao", "Netherlands")
cities[nrow(cities) + 1, ] <- c("Washington, D.C.", "United States")
cities[nrow(cities) + 1, ] <- c("Deep River", "Canada")
cities[nrow(cities) + 1, ] <- c("Harlem", "United States")
cities[nrow(cities) + 1, ] <- c("Christ Church", "New Zealand")
cities[nrow(cities) + 1, ] <- c("Demerara-Mahaica", "Guyana")
cities[nrow(cities) + 1, ] <- c("County Antrim", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Saint-Linâ???", "Canada")
cities[nrow(cities) + 1, ] <- c("Laurentides", "Canada")
cities[nrow(cities) + 1, ] <- c("Incisa in Val d'Arno", "Italy")
cities[nrow(cities) + 1, ] <- c("Bellaghy", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Tel-Aviv", "Israel")
cities[nrow(cities) + 1, ] <- c("Lyonshall", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("City of Canterbury", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Cardiff", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Haverfordwest", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Manitoba", "Canada")
cities[nrow(cities) + 1, ] <- c("Comunidad de Madrid", "Spain")
cities[nrow(cities) + 1, ] <- c("Long Island City", "United States")
cities[nrow(cities) + 1, ] <- c("Long Island", "United States")
cities[nrow(cities) + 1, ] <- c("Andhra Pradesh", "India")
cities[nrow(cities) + 1, ] <- c("Clenze", "Germany")
cities[nrow(cities) + 1, ] <- c("Grande-VallÃ©e", "Canada")
cities[nrow(cities) + 1, ] <- c("Poitou-Charentes", "France")
cities[nrow(cities) + 1, ] <- c("Hauterive", "France")
cities[nrow(cities) + 1, ] <- c("PocÃ©-sur-Cisse", "France")
cities[nrow(cities) + 1, ] <- c("Dartford", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Wrexham", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Staffordshire", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Katrineholm Municipality", "Sweden")
cities[nrow(cities) + 1, ] <- c("Northern Cyprus", "Cyprus")
cities[nrow(cities) + 1, ] <- c("Lefka", "Cyprus")
cities[nrow(cities) + 1, ] <- c("RhÃ´ne-Alpes", "France")
cities[nrow(cities) + 1, ] <- c("Wales", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Richmond upon Thames", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Suffolk County", "United States")
cities[nrow(cities) + 1, ] <- c("Pointe-aux-Trembles", "Canada")
cities[nrow(cities) + 1, ] <- c("Ynysddu", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Clonakilty", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Rusholme", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Sankt-Peterburg", "Russia")
cities[nrow(cities) + 1, ] <- c("Stanford-le-Hope", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Uddevalla Municipality", "Sweden")
cities[nrow(cities) + 1, ] <- c("Veneto", "Italy")
cities[nrow(cities) + 1, ] <- c("Monte-Carlo", "Monaco")
cities[nrow(cities) + 1, ] <- c("Faroe Islands", "Denmark")
cities[nrow(cities) + 1, ] <- c("HoyvÃk", "Denmark")
cities[nrow(cities) + 1, ] <- c("Bethnal Green", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Enschede", "Netherlands")
cities[nrow(cities) + 1, ] <- c("Czechoslovakia", "Czech Republic")
cities[nrow(cities) + 1, ] <- c("Praha", "Czech Republic")
cities[nrow(cities) + 1, ] <- c("New South Wales", "Australia")
cities[nrow(cities) + 1, ] <- c("Wormley", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("East Hoathly", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Hudiksvall Municipality", "Sweden")
cities[nrow(cities) + 1, ] <- c("Maharashtra", "India")
cities[nrow(cities) + 1, ] <- c("Vizcaya", "Spain")
cities[nrow(cities) + 1, ] <- c("Saddle River", "United States")
cities[nrow(cities) + 1, ] <- c("Croix-des-Bouquets", "Haiti")
cities[nrow(cities) + 1, ] <- c("British Virgin Islands", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Fregona", "Italy")
cities[nrow(cities) + 1, ] <- c("Kobe", "Japan")
cities[nrow(cities) + 1, ] <- c("AndalucÃ?a", "Spain")


artists[,1] <- as.character(artists[,1]) # make character to do string comprehension
artists[,2] <- as.character(artists[,2]) # make character to do string comprehension

for (i in 1:nrow(artists)) {
  country <- strsplit(artists[i,2], '["":""]')[[1]][17] # get only the country
  artists[i,3] <- country
  
  city <- strsplit(artists[i,2], '["":""]')[[1]][26] # get only the city
  artists[i,4] <- city
  
  if ((artists[i,3] %in% countries) == FALSE) { # this means that it is not a country in the country field
    if ((artists[i,3] %in% cities$city) == TRUE) { # check if the "country" is actually a city -> we can get the country
      correct_country <- cities[which(cities$city == artists[i,3]),2] # if yes, get the country
      if (length(correct_country) == 1) { # if only one item in "cities" match -> assign to artist
        artists[i,3] <- correct_country
      } else if(length(unique(correct_country)) == 1) { # if more than one item in "cities" match but they are actually the same -> assign the first one to artist
        artists[i,3] <- correct_country[1]
      } else if(length(unique(correct_country)) > 1) { # if more than one "city" matches we do not know the country -> assign "Unknown"
        artists[i,3] <- "Unknown"
      }
    } else if((artists[i,3] %in% states) == TRUE) { # the "city" is actually a state in the US, so assign "United States"
      artists[i,3] <- "United States"
    } else if((artists[i,4] %in% countries) == TRUE){ # if we couldn't match the "country", try to get the country in the cities db using the city field in artists
      artists[i,3] <- artists[i,4]
    } else if ((artists[i,4] %in% cities$city) == TRUE) { # check if the city is in "cities" and get the country
      correct_country <- cities[which(cities$city == artists[i,4]),2]
      if (length(correct_country) == 1) { # if only one item in "cities" match -> assign to artist
        artists[i,3] <- correct_country
      } else if(length(unique(correct_country)) == 1) { # if more than one item in "cities" match but they are actually the same -> assign the first one to artist
        artists[i,3] <- correct_country[1]
      } else if(length(unique(correct_country)) > 1) { # if more than one "city" matches we do not know the country -> assign "Unknown"
        artists[i,3] <- "Unknown"
      } 
    } else { # if the city is not found in the cities dataset, add it to a list to handle separately
      if ((artists[i,3] != "") | (artists[i,4] != "")){ # if there is no data on either the city or country -> assign "Unknown"
        artists[i,3] <- "Unknown"
      }
    }
    
  } 
  if (artists[i,3] == ""){ # if there is no data on the country -> assign "Unknown"
    artists[i,3] <- "Unknown"
  }
  
  if (i %% 1000 == 0){ # just to see progress
    print(i)
  }
  
}

artists_1 <- artists[,c(1,3)] # create new dataframe since it is correct now

# remove "object()" from id to be able to merge with the rest of the data
for (i in 1:nrow(artists_1)) {
  if (grepl("(", artists_1[i,1], fixed = TRUE)) { # not all fields contain the "object()"
    artists_1[i,1] <- unlist(strsplit(artists_1[i,1], split='(', fixed=TRUE))[2] # remove "object("
    artists_1[i,1] <- unlist(strsplit(artists_1[i,1], split=')', fixed=TRUE))[1] # remove ")"
  }
  if (i %% 1000 == 0){
    print(i)
  }
}

names(artists_1)[names(artists_1) == "V3"] <- "country"
names(artists_1)[names(artists_1) == "X_id"] <- "id_artist"

# write a new csv file with the clean data to be used later.
write.csv(artists_1, "./Data_for_cleaning/artists_clean.csv")

artists_clean <- read.csv(file = "./Data_for_cleaning/artists_clean.csv")
#artists_clean <- artists_clean[,c(2,3)]

marlize_dataset <- merge(marlize_dataset, artists_clean, by="id_artist") # it merges correctly, because the dataframe has the same number of rows - meaning no rows were dropped


### CLEANING THE SONGS DATASET ###

songs <- songs[,c(2,3)]
songs[,1] <- as.character(songs[,1]) # make character to do string comprehension

for (i in 1668015:nrow(songs)) {
  if (grepl("(", songs[i,1], fixed = TRUE)) { # not all fields contain the "object()"
    songs[i,1] <- unlist(strsplit(songs[i,1], split='(', fixed=TRUE))[2] # remove "object("
    songs[i,1] <- unlist(strsplit(songs[i,1], split=')', fixed=TRUE))[1] # remove ")"
  }
  
  if (songs[i,2] != "" & songs[i,2] != "[]") {
    songs$award_TF[i] = TRUE
  } else {
    songs$award_TF[i] = FALSE
  }
  if (i %% 1000 == 0){
    print(i)
  }
}

# we now need to count the number of awards each album received.
library(dplyr)
songs_by_ablum <- songs
songs_by_ablum <- songs %>% group_by(id_album) %>% summarise(count = sum(award_TF == TRUE))

names(songs_by_ablum)[names(songs_by_ablum) == "id_album"] <- "X_id"

marlize_dataset <- merge(marlize_dataset, songs_by_ablum, by = 'X_id', all.y = TRUE, all.x = TRUE)
names(marlize_dataset)[names(marlize_dataset) == "count"] <- "award_count"
names(marlize_dataset)[names(marlize_dataset) == "X_id"] <- "id_album"

# since there are less albums in the songs_by_albums dataset than in the big dataset, there are NA's in the big dataset
# - specifically in column 6 - the awards column.
# we need to replace these NA's with "Unknown", because we do not know if songs in the album received an award or not.

library(tidyr)
marlize_dataset$award_count <- marlize_dataset$award_count %>% replace_na("Unknown")

write.csv(songs, file = "./Data_for_cleaning/songs_clean.csv")

write.csv(albums_1, file = "./Data_for_cleaning/albums_clean.csv")

marlize_dataset <- read.csv(file = "./Data_for_cleaning/Marlize_data_clean.csv")
marlize_dataset$country <- as.character(marlize_dataset$country)

# Now we create the final dataset for the visualisation. First we will focus on the awards.
dataset_1 <- marlize_dataset[,c(8,10,11)]

dataset_1$country <- as.factor(dataset_1$country)
dataset_1$country <- droplevels(dataset_1$country)
# getting the number of awards
dataset_1$award_count <- as.integer(as.character(dataset_1$award_count))
# if the field is NA it means that there were no awards, so we set NA = 0
for (i in 1:nrow(dataset_1)) {
  if (is.na(dataset_1$award_count[i]) == TRUE) {
    dataset_1$award_count[i] = 0
  }
}

# some more cleaning that was found to be necessary
dataset_1$country <- as.character(dataset_1$country)
for (i in 1:nrow(dataset_1)) {
  if (dataset_1$country[i] == "CÃ´te Dâ???TIvoire") {
    dataset_1$country[i] <- "Cote d'Ivoire"
  }
  
  if (dataset_1$country[i] == "Bahamas" | dataset_1$country[i] == "Bahamas, The") {
    dataset_1$country[i] <- "The Bahamas"
  }
  
  if (dataset_1$country[i] == "Hong Kong") {
    dataset_1$country[i] <- "China"
  }
  
  if (dataset_1$country[i] == "Czechia") {
    dataset_1$country[i] <- "Czech Republic"
  }
  
  if (dataset_1$country[i] == "Bosnia And Herzegovina") {
    dataset_1$country[i] <- "Bosnia and Herzegovina"
  }
  
  if (dataset_1$country[i] == "Guadeloupe") {
    dataset_1$country[i] <- "France"
  }
  
  if (dataset_1$country[i] == "Martinique") {
    dataset_1$country[i] <- "France"
  }
}

# now we group the data by publication date and country and sum the number of awards to get the total number of awards.
dataset_1_grouped <- dataset_1 %>% group_by(publicationDate, country) %>% summarise(total_awards = sum(award_count))

# some more cleaning and then regrouping
dataset_1_grouped$publicationDate[1391] <- substr(dataset_1_grouped$publicationDate[1391], 1, 4)
dataset_1_grouped$publicationDate[2132] <- substr(dataset_1_grouped$publicationDate[2132], 1, 4)
dataset_1_grouped$publicationDate[2133] <- substr(dataset_1_grouped$publicationDate[2133], 1, 4)

dataset_1_grouped <- dataset_1_grouped %>% group_by(publicationDate, country) %>% summarise(total_awards = sum(total_awards))

dataset_1_grouped$publicationDate[2903] <- "Unknown"

dataset_1_grouped <- dataset_1_grouped %>% group_by(publicationDate, country) %>% summarise(total_awards = sum(total_awards))

# now we will get the number of albums released by grouping the data by the publication date and country and then
# summing the total observations in each group.
dataset_2_grouped <- dataset_1 %>% group_by(publicationDate, country) %>% mutate(count = n())

# there are duplicates so we get the distinct cases and then regroup.
dataset_2_grouped <- distinct(dataset_2_grouped)

dataset_2_grouped <- dataset_2_grouped[,-c(3)]

dataset_2_grouped <- distinct(dataset_2_grouped)

dataset_2_grouped <- dataset_2_grouped %>% group_by(publicationDate, country) %>% summarise(albumCount = sum(count))

# finally we merge the data sets.
grouped_data <- merge(x=dataset_1_grouped,y=dataset_2_grouped,by=c("publicationDate", "country"),all.x=TRUE)

# a dataset with the coordinates of each country's capital - to be used for positioning the bubbles
coord_cap <- read.csv(file = "./Data_for_cleaning/concap.csv")
coord_cap$CapitalLatitude <- as.character(coord_cap$CapitalLatitude)
coord_cap$CapitalLongitude <- as.character(coord_cap$CapitalLongitude)
coord_cap$CountryName <- as.character(coord_cap$CountryName)
coord_cap$ContinentName <- as.character(coord_cap$ContinentName)

coord_cap$CountryName[24] <- "The Bahamas"

# add columns to cleaned dataset
grouped_data$lat <- NA
grouped_data$lon <- NA
grouped_data$continent <- NA

grouped_data$country <- as.character(grouped_data$country)

# get coordinates for each country
for (i in 1:nrow(grouped_data)) {
  if ((grouped_data[i,2] %in% coord_cap$CountryName) == TRUE){
    grouped_data$lat[i] <- coord_cap[which(coord_cap$CountryName == as.character(grouped_data[i,2])),3]
    grouped_data$lon[i] <- coord_cap[which(coord_cap$CountryName == as.character(grouped_data[i,2])),4]
    grouped_data$continent[i] <- coord_cap[which(coord_cap$CountryName == as.character(grouped_data[i,2])),6]
  } else {
    grouped_data$lat[i] <- "Unknown"
    grouped_data$lon[i] <- "Unknown"
    grouped_data$continent[i] <- "Unknown"
  }
}

# save the clean dataset

write.csv(grouped_data, file = "./Data_for_cleaning/data_clean_for_viz.csv")