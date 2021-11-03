
library(dplyr)
library(tidyverse)



#ATTENTION: Between HERE-1 and HERE-2, you should keep them in comment since they read the
#whole wasabi_songs.csv data and split the song genres. It also separates the genres "Not specified"
#because they are a lot and they don't need to be splitted.
#It takes a lot of time and it is done just one time. So, you run these code just once. 
#At the end you write the splitted genres
#into a file called Songs_genres_splitted.csv. After, you use this file, not the whole dataset.
#
#Example splitting:
#BEFORE SPLITTING:
#2098839,"ObjectId(5714deed25ac0d8aee580a75)","[Hard rock", "Rock music"]
#
#AFTER SPLITTING:
#2098839,"ObjectId(5714deed25ac0d8aee580a75)","Hard rock"
#2098839,"ObjectId(5714deed25ac0d8aee580a75)","Rock music"
#HERE-1:
# #Download wasabi songs
# wasabi_songs <- read.csv("Downloads/wasabi/wasabi_songs.csv",sep = "\t")
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
# total_row=nrow(df_clean)
# total_row
# j<-1
# #Split the genres of songs in the below while loop
# while(j<=total_row){
#   df_clean<- add_row(df_clean[1,],df_clean)
#   j <- j+1
# }
# 
# write.csv(df_clean,"Downloads/Songs_genres_splitted.csv", row.names = FALSE)
# HERE-2.

#Load the splitted genres data

df_splitted <- read.csv("Downloads/Songs_genres_splitted.csv")
#temp_df<-head(df_splitted,100)
df_splitted <- df_splitted %>% mutate(grouped_genre= "not_decided")
head(df_splitted)


find_genre <- function(one_row,df,index){

  if(grepl(paste(c("rock", "Rock"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"rock"  
  }
  else if(grepl(paste(c("pop", "Pop"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"pop" }
  else if(grepl(paste(c("Metal", "metal"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"metal" }
  else if(grepl(paste(c("hip", "Hip","hop","Hop"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"hip-hop" }
  else if(grepl(paste(c("blue", "Blue"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"blues" }
  
  else if(grepl(paste(c("dance", "Dance","Disco", "disco"), collapse="|"), one_row$genre)){
    #Attention: Disco is a dance music genre
    df$grouped_genre[index]<-"dance_music" }
  else if(grepl(paste(c("elect", "Elect"), collapse="|"), one_row$genre)){
    #Attention: Electronic dance music is in dance music genre, not in electronic music genre
    df$grouped_genre[index]<-"electronic" }
  else if(grepl(paste(c("jazz", "Jazz"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"jazz" }
  else if(grepl(paste(c("Reggae", "reggae"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"reggae" }

  else if(grepl(paste(c("Country", "country"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"country" }
  
  else if(grepl(paste(c("Funk", "funk"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"funk" }
  else if(grepl(paste(c("House", "house"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"house" }
  else if(grepl(paste(c("Rap", "rap"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"rap" }
  else if(grepl(paste(c("Folk", "folk"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"folk" }
  
  else if(grepl(paste(c("Soul", "soul"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"soul" }
  else if(grepl(paste(c("punk", "Punk"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"punk" }
  else if(grepl(paste(c("Wave", "wave"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"new_wave" }
  else if(grepl(paste(c("psy", "Psy"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"psychedelic" }
  
  else if(grepl(paste(c("Christmas", "christmas"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"christmas" }
  else if(grepl(paste(c("trance", "Trance"), collapse="|"), one_row$genre)){
    df$grouped_genre[index]<-"trance" }

  return(df)
  # df[nrow(df) + 1,] <- c(one_row["X"],one_row["X_id"], one_row["genre"],temp_genre)
}


#Split the genres of songs in the below while loop
j<-1
total_row<- nrow(df_splitted)
while(j<=total_row){
  df_splitted<- find_genre(df_splitted[j,],df_splitted,j)
  j <- j+1
}
head(df_splitted,15)
print("bitti,yaziyor")
write.csv(df_splitted,"Downloads/songs_genres_grouped.csv", row.names = FALSE)
