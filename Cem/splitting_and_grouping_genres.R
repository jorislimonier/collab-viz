
library(dplyr)
library(tidyverse)



#For each part, you need to uncomment it and run individually.
#
#PART-1
#Read the wasabi dataset
wasabi_songs <- read.csv("wasabi/wasabi_songs.csv",sep = "\t")
#Select columns that we are gonna use
df <- wasabi_songs %>% select("X", "X_id","genre","publicationDate")

#Find non-exists genres and make them "Not specified"
df$genre[df$genre == ""] <- NA
df$genre[df$genre == "[]"] <- NA
df$genre[is.na(df$genre)] <- "Not specified"

#Find non-exists publicationDates and make them "0000"
df$publicationDate[df$publicationDate == ""] <- NA
df$publicationDate[df$publicationDate == "[]"] <- NA
df$publicationDate[is.na(df$publicationDate)] <- "0000"

######################################################################
######################################################################
#Part-1.1
#Data Manupilation for Not-Given Genres:


#Take the songs with not_specified genres and create a different .csv file for them
df_not_specified <- df %>% filter(genre == "Not specified" )
df_not_specified<- df_not_specified %>%mutate(new_year = "coming")

print("1")
for(i in seq(1:nrow(df_not_specified))){
  year <- df_not_specified$publicationDate[i]
  #Only take the year, not day and month. Ex: 1998-06-22 becomes 1998
  year<- substring(year , first=1, last=4)
  df_not_specified$new_year[i] <- year

}
#Remove the publicationDate column
df_not_specified$publicationDate <- NULL
#Change column names
colnames(df_not_specified) <- c('index','song_id',"genre", 'publicationDate')
head(df_not_specified)
print("writing")
write.csv(df_not_specified,"Not_specified_genres.csv", row.names = FALSE)
######################################################################
######################################################################


########################################################################################
########################################################################################
#Part-1.2
#
#Data Manipulation for given genres:
#
#
#This function is used in splitting the genres of songs
# add_row <- function(one_row, df){
#   #Split the genre column values. One song can have multiple genres. We separate genres here.
#   #Example: 
#   # ObjectId(5714dec325ac0d8aee38093d)","metal, punk, rock" 
#   #becomes:
#   #
#   # ObjectId(5714dec325ac0d8aee38093d)","metal"
#   # ObjectId(5714dec325ac0d8aee38093d)","punk"
#   # ObjectId(5714dec325ac0d8aee38093d)","rock".
#   #
#   temp_str <- one_row  %>% select("genre")
#   temp_str <- substring(temp_str , first=2, last=nchar(temp_str)-1)
#   temp_str <- str_split(temp_str, ",")
#   v1 <- unlist(temp_str)
#   #Crop publication date and only take year, not month and day.Ex: 1998-06-22 becomes 1998
#   year <- one_row  %>% select("publicationDate")
#   year<- substring(year , first=1, last=4)
#   #Add the new rows to the end of dataframe:
#   for(i in seq(1:length(v1))){
#     temp_genre<-substring(v1[i] , first=2, last=nchar(v1[i])-1)
#     df[nrow(df) + 1,] <- c(one_row["X"],one_row["X_id"],  temp_genre,year)
#   }
#   #Delete the current row:
#   neww_df <- df[-1,]
#   return(neww_df)
# }
# #df_clean is data frame without genres "Not specified"
# df_clean <- df %>% filter(genre!= "Not specified" )
# total_row=nrow(df_clean)
# total_row
# j<-1
# #Split the genres of songs in the below while loop
# while(j<=total_row){
#   df_clean<- add_row(df_clean[1,],df_clean)
#   j <- j+1
# }
# #Write the new dataframe into a .csv file:
# write.csv(df_clean,"Songs_genres_splitted.csv", row.names = FALSE)
########################################################################################
########################################################################################






#PART-2
#Creating genres with grouped genres:
#Load the splitted genres data

 # df_splitted <- read.csv("Songs_genres_splitted.csv")
 # df_splitted <- df_splitted %>% mutate(grouped_genre= "not_decided")
 # 
 # find_genre <- function(one_row,df,index){
 # 
 #   if(grepl(paste(c("rock", "Rock","surf","Surf","Industrial","British Invasion","Shoegazing","Sentimental ballad","Minneapolis sound",
 #                    "Neue Deutsche Welle","Experimental","Beat","Neue Deutsche Härte","Palm Desert Scene",
 #                    "Adult","Motown","Dark","dark"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"rock"
 # 
 #   }
 #   else if(grepl(paste(c("pop", "Pop","Wall of Sound","Beach","Vocal","hall"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"pop"
 # 
 #     }
 #   else if(grepl(paste(c("Metal", "metal","Death"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"metal" }
 #   else if(grepl(paste(c("hip", "Hip","hop","Hop","New jack swing","Miami bass","Hyphy","Lo-fi","Crunk","East","Swing","Breakbeat",
 #                         "Jumpstyle","Hands","Yé-yé","procedural","Snap"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"hip-hop" }
 #   else if(grepl(paste(c("blue", "Blue","Liedermacher","Boogie-woogie","Bolero","Tulsa Sound","Singer-songwriter"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"blues" }
 #   #Attention: Disco is a dance music genre
 #   else if(grepl(paste(c("dance", "Dance","Disco", "disco","Hi-NRG","garage","Garage","Speed garage","Freestyle","Bhangra","Cabaret","Low","Sirtaki",
 #                         "Tropicália"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"dance_music" }
 #   #Attention: Electronic dance music is in dance music genre, not in electronic music genre
 #   else if(grepl(paste(c("elect", "Elect","Big beat","Grime","Électronique","électronique","Remix"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"electronic" }
 #   else if(grepl(paste(c("jazz", "Jazz","Quiet storm","Afrobeat","Dixieland","Stride","Screamo","Pan","cumbia"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"jazz" }
 #   else if(grepl(paste(c("Reggae", "reggae","Dubstep","step","Ska","Dub","Oldschool jungle","Old-time","Mento","black","Ragtime"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"reggae" }
 # 
 #   else if(grepl(paste(c("Country", "country","Honky-tonk","Music of Lubboc","Texas","Music of Ireland","Western","Moombahton","Kuduro"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"country" }
 # 
 #   else if(grepl(paste(c("Funk", "funk","Show","World","Go-go","Musique"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"funk" }
 #   else if(grepl(paste(c("House", "house","Lullaby","Teenage","Plunderphonics","Balada","Gaana"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"house" }
 #   else if(grepl(paste(c("Rap", "rap","Ballad","Hardstyle","Free"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"rap" }
 #   else if(grepl(paste(c("Folk", "folk","skiffle","Skiffle","Tejano","Baggy","Protest","Topical","Music of Scotland","Laïko","Boogie","song"
 #                         ,"Choir","Ballet"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"folk" }
 # 
 #   else if(grepl(paste(c("Soul", "soul","Stoner","Kwaito","Highlife"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"soul" }
 #   else if(grepl(paste(c("punk", "Punk","Emo","Ragga","PBR","Mariachi","Candombe","Junkanoo"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"punk" }
 #   else if(grepl(paste(c("Wave", "wave","New","Cumbia","New-age"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"new_wave" }
 #   else if(grepl(paste(c("psy", "Psy"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"psychedelic" }
 # 
 #   else if(grepl(paste(c("Christmas", "christmas"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"christmas" }
 #   else if(grepl(paste(c("trance", "Trance","contemporain","Contemporain"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"trance" }
 #   ###################
 #   else if(grepl(paste(c("techno", "Techno","Downtempo"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"techno" }
 #   else if(grepl(paste(c("Latin", "latin","Bachata","bachata","Samba","samba","Salsa","salsa","Bossa","Pasodoble","rumba","Flamenco","Zumba"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"latin" }
 #   else if(grepl(paste(c("contemporary", "Contemporary","Madchester","Baroque"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"contemporary" }
 #   else if(grepl(paste(c("Grunge", "grunge","Post-grunge"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"grunge" }
 #   else if(grepl(paste(c("opera", "Opera","Classical","classical","orchestra","Orchestra","Crossover",
 #                         "Ambient","Patriotic","Piano","Neoclassicism","Waltz","Música sertaneja","Tex-Mex","sound","Sound"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"classical_music" }
 #   else if(grepl(paste(c("Hardcore","core","Hard", "hardcore","California Sound","Exotica"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"hardcore" }
 #   else if(grepl(paste(c("Harmony", "harmony","doo-wop","Doo-wop","Drone","Worldbeat","beat","Schlager","Bounce","A cappella","Music of Italy"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"harmony" }

 #   else if(grepl(paste(c("Poetry", "poetry","Chanson","Ballade"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"poetry" }
 #   else if(grepl(paste(c("Acoustic", "acoustic","Easy listening","Bebop"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"acoustic" }
 #   else if(grepl(paste(c("religious", "Hymn","Christian","Gospel","Siren","Spoken","Feminism"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"religious" }
 #   else if(grepl(paste(c("Celtic"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"celtic" }
 #   else if(grepl(paste(c("Novelty","Parody","Comedy"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"comedy_songs" }
 #   else if(grepl(paste(c("Instrumental","Minimal","World","band","jam","bass","Soundtrack","Film score","March","world","Musique concrète","Kayōkyoku",
 #                         "Jimmy Buffett","Americana","Circus","Calypso","Music","music","Mod","mod","Gabber","Porn","française","French",
 #                        "EDM" ,"Pain","Alternative","show","Action","Doctor Who fandom"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"instrumental" }
 #   else if(grepl(paste(c("Avant-garde","theatre","Theatre","Charity"), collapse="|"), one_row$genre)){
 #     df$grouped_genre[index]<-"theatre" }
 # 
 #   return(df)
 # 
 # }
 # 
 # #Split the genres of songs in the below while loop
 # j<-1
 # total_row<- nrow(df_splitted)
 # total_row
 # #dff<- df_splitted
 # while(j<=total_row){
 #   df_splitted<- find_genre(df_splitted[j,],df_splitted,j)
 #    print(j)
 #   j <- j+1
 # }
 # head(df_splitted)
 # total_row
 # nrow(df_splitted)
 # print("bitti,yaziyor")
 # write.csv(df_splitted,"songs_genres_grouped.csv", row.names = FALSE)




#PART-3
#Here I change the column names:
# df_grouped <- read.csv("songs_genres_grouped.csv")
#  colnames(df_grouped) <- c('index','song_id',"genre", 'publicationDate',"grouped_genre")
# write.csv(df_grouped,"songs_genres_grouped.csv", row.names = FALSE)


