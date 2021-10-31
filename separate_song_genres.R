
library(dplyr)
library(tidyverse)




#Download wasabi songs
#wasabi_songs <- read.csv("Downloads/wasabi/wasabi_songs.csv",sep = "\t")
# df <- wasabi_songs %>% select("X", "X_id","genre")
# head(df,2)
# 
# #This function is used in splitting the genres of songs
# add_row <- function(one_row, df){
#   temp_str <- one_row  %>% select("genre")
#   temp_str <- substring(temp_str , first=2, last=nchar(temp_str)-1)
#   temp_str <- str_split(temp_str, ",")
#   v1 <- unlist(temp_str)
#   for(i in seq(1:length(v1))){
#     temp_genre<-substring(v1[i] , first=2, last=nchar(v1[i])-1)
#     df[nrow(df) + 1,] <- c(one_row["X"],one_row["X_id"], temp_genre)
#   }
#   #neww_df <- subset(df, genre != one_row$genre)
#   neww_df <- df[-1,]
#   return(neww_df)
#   }
# 
# 
# data_new1 <- df                                    
# data_new1[data_new1 == ""] <- NA
# data_new1[data_new1 == "[]"] <- NA
# data_new1[is.na(data_new1)] <- "Not specified"
# 
# 
# 
# 
# #df_clean is data frame without genres "Not specified" 
# df_clean <- data_new1 %>% filter(genre!= "Not specified" )
# head(df_clean,10)
# 
# head(data_new1,10)
# total_row=nrow(data_new1)
# total_row
# j<-1
#Split the genres of songs in the below while loop
# while(j<=total_row){
#   data_new1<- add_row(data_new1[1,],data_new1)
#   j <- j+1
# }
# 
# #write.csv(data_new1,"Downloads/Songs_genres_splitted.csv", row.names = FALSE)

#Load the splitted genres data
df_splitted <- read.csv("Downloads/splitted_songs_genres.csv")
head(df_splitted)

##########################################################
##########################################################
#ROCK
#
#
patterns <- c("rock", "Rock")
rock_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
write.csv(rock_df,"Downloads/Rock.csv", row.names = FALSE)
#Extract rock genre from the whole df
df_splitted <- setdiff(df_splitted, rock_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#POP
#
#Take the rows if the genre has "pop" in it.
patterns <- c("pop", "Pop")
pop_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
write.csv(pop_df,"Downloads/Pop.csv", row.names = FALSE)
#Extract pop genre from the whole df
df_splitted <- setdiff(df_splitted, pop_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#METAL
#
#Take the rows if the genre has "Metal" or "metal" in it.
patterns <- c("Metal", "metal")
metal_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(metal_df,"Downloads/Metal.csv", row.names = FALSE)
#Extract metal genre from the whole df
df_splitted <- setdiff(df_splitted, metal_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#HIP-HOP
#
#Take the rows if the genre has "hip" or "Hip" in it.
patterns <- c("hip", "Hip","hop","Hop")
hip_hop_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(hip_hop_df,"Downloads/Hip_hop.csv", row.names = FALSE)
#Extract hip_hop genre from the whole df
df_splitted <- setdiff(df_splitted, hip_hop_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#Blues
#
#Take the rows if the genre has "blue" or "Blue" in it.
patterns <- c("blue", "Blue")
blues_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(blues_df,"Downloads/Blues.csv", row.names = FALSE)
#Extract blues_df genre from the whole df
df_splitted <- setdiff(df_splitted, blues_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#Dance music (includes electronic dance music so this is before the electronic music)
#
#Take the rows if the genre has "dance" or "Dance" in it.
patterns <- c("dance", "Dance")
dance_music_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(dance_music_df,"Downloads/Dance_music.csv", row.names = FALSE)
#Extract dance_music_df genre from the whole df
df_splitted <- setdiff(df_splitted, dance_music_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#ELECTRONIC
#
#Take the rows if the genre has "elect" or "Elect" in it.
patterns <- c("elect", "Elect")
electronic_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(electronic_df,"Downloads/electronic.csv", row.names = FALSE)
#Extract electronic_df genre from the whole df
df_splitted <- setdiff(df_splitted, electronic_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#JAZZ
#
#Take the rows if the genre has "jazz" or "Jazz" in it.
patterns <- c("jazz", "Jazz")
jazz_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(jazz_df,"Downloads/Jazz.csv", row.names = FALSE)
#Extract jazz_df genre from the whole df
df_splitted <- setdiff(df_splitted, jazz_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Reggae
#
#Take the rows if the genre has "Reggae" or "reggae" in it.
patterns <- c("Reggae", "reggae")
reggae_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(reggae_df,"Downloads/Reggae.csv", row.names = FALSE)
#Extract reggae_df genre from the whole df
df_splitted <- setdiff(df_splitted, reggae_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Disco
#
#Take the rows if the genre has "Disco" or "disco" in it.
patterns <- c("Disco", "disco")
disco_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(disco_df,"Downloads/Disco.csv", row.names = FALSE)
#Extract disco_df genre from the whole df
df_splitted <- setdiff(df_splitted, disco_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)



##########################################################
##########################################################
#Country
#
#Take the rows if the genre has "Country" or "country" in it.
patterns <- c("Country", "country")
country_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(country_df,"Downloads/Country.csv", row.names = FALSE)
#Extract country_df genre from the whole df
df_splitted <- setdiff(df_splitted, country_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#Funk
#
#Take the rows if the genre has "Funk" or "funk" in it.
patterns <- c("Funk", "funk")
funk_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(funk_df,"Downloads/Funk.csv", row.names = FALSE)
#Extract funk_df genre from the whole df
df_splitted <- setdiff(df_splitted, funk_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#House
#
#Take the rows if the genre has "House" or "house" in it.
patterns <- c("House", "house")
house_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(house_df,"Downloads/House.csv", row.names = FALSE)
#Extract house_df genre from the whole df
df_splitted <- setdiff(df_splitted, house_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#Rap
#
#Take the rows if the genre has "rap" or "Rap" in it.
patterns <- c("Rap", "rap")
rap_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(rap_df,"Downloads/Rap.csv", row.names = FALSE)
#Extract rap_df genre from the whole df
df_splitted <- setdiff(df_splitted, rap_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Folk
#
#Take the rows if the genre has "Folk" or "folk" in it.
patterns <- c("Folk", "folk")
folk_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(folk_df,"Downloads/Folk.csv", row.names = FALSE)
#Extract folk_df genre from the whole df
df_splitted <- setdiff(df_splitted, folk_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)



##########################################################
##########################################################
#Soul
#
#Take the rows if the genre has "Soul" or "soul" in it.
patterns <- c("Soul", "soul")
soul_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(soul_df,"Downloads/Soul.csv", row.names = FALSE)
#Extract soul_df genre from the whole df
df_splitted <- setdiff(df_splitted, soul_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)

##########################################################
##########################################################
#Punk
#
#Take the rows if the genre has "Punk" or "punk" in it.
patterns <- c("punk", "Punk")
punk_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(punk_df,"Downloads/Punk.csv", row.names = FALSE)
#Extract punk_df genre from the whole df
df_splitted <- setdiff(df_splitted, punk_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#New_wave
#
#Take the rows if the genre has "Wave" or "wave" in it.
patterns <- c("Wave", "wave")
new_wave_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(new_wave_df,"Downloads/New_wave.csv", row.names = FALSE)
#Extract new_wave_df genre from the whole df
df_splitted <- setdiff(df_splitted, new_wave_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Psychedelic
#
#Take the rows if the genre has "psy" or "Psy" in it.
patterns <- c("psy", "Psy")
psychedelic_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(psychedelic_df,"Downloads/Psychedelic.csv", row.names = FALSE)
#Extract psychedelic_df genre from the whole df
df_splitted <- setdiff(df_splitted, psychedelic_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Christmas music
#
#Take the rows if the genre has "Christmas" or "christmas" in it.
patterns <- c("Christmas", "christmas")
christmas_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(christmas_df,"Downloads/Christmas.csv", row.names = FALSE)
#Extract christmas_df genre from the whole df
df_splitted <- setdiff(df_splitted, christmas_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)


##########################################################
##########################################################
#Trance music
#
#Take the rows if the genre has "Trance" or "trance" in it.
patterns <- c("trance", "Trance")
trance_df <- filter(df_splitted, grepl(paste(patterns, collapse="|"), genre))
#And write the new df to a csv file
write.csv(trance_df,"Downloads/Trance.csv", row.names = FALSE)
#Extract trance_df genre from the whole df
df_splitted <- setdiff(df_splitted, trance_df)
#Write the rest of the genres to a csv file to see clearly what genres are left
write.csv(df_splitted,"Downloads/rest.csv", row.names = FALSE)