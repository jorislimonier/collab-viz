rm(list = ls())
setwd("~/Marlize/2021/Frankryk/Klasse/Data Visualisation/Project")

artists <- read.csv(file = "../Data/artists_cols.csv")

cities <- read.csv("../Data/worldcities.csv")

# a list of countries that will be used to identify if the "Country" entry is actually a country because some are cities.
# "Unknown" was added because entries without a country will be classified as unknown.
countries <- c("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia",
               "Australia", "Austria", "Azerbaijan", "The Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus",
               "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil",
               "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada",
               "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros",
               "Democratic Republic of the Congo", "Republic of the Congo", "Costa Rica", "C�te d'Ivoire", "Croatia",
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
cities[nrow(cities) + 1, ] <- c("Jonquière", "Canada")
cities[nrow(cities) + 1, ] <- c("Montserrat", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Frankfurt am Main", "Germany")
cities[nrow(cities) + 1, ] <- c("Offenbach am Main", "Germany")
cities[nrow(cities) + 1, ] <- c("Osaka", "Japan")
cities[nrow(cities) + 1, ] <- c("Kyoto", "Japan")
cities[nrow(cities) + 1, ] <- c("Maui County", "United States")
cities[nrow(cities) + 1, ] <- c("Pa�?s Vasco", "Spain")
cities[nrow(cities) + 1, ] <- c("Guipúzcoa", "Spain")
cities[nrow(cities) + 1, ] <- c("Ciudad de México", "Mexico")
cities[nrow(cities) + 1, ] <- c("East Germany", "Germany")
cities[nrow(cities) + 1, ] <- c("Noord-Brabant", "Netherlands")
cities[nrow(cities) + 1, ] <- c("Michoacán", "Mexico")
cities[nrow(cities) + 1, ] <- c("Cheshire East", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Gedding", "United States")
cities[nrow(cities) + 1, ] <- c("Lewisham", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Val-d'Or", "Canada")
cities[nrow(cities) + 1, ] <- c("Nelson City", "New Zealand")
cities[nrow(cities) + 1, ] <- c("Northern Ireland", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Región Metropolitana de Santiago", "Chile")
cities[nrow(cities) + 1, ] <- c("Zurich", "Switzerland")
cities[nrow(cities) + 1, ] <- c("England", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Camberwell", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("The Bronx", "United States")
cities[nrow(cities) + 1, ] <- c("La Habana", "Cuba")
cities[nrow(cities) + 1, ] <- c("Landsberg am Lech", "Germany")
cities[nrow(cities) + 1, ] <- c("Bergen auf Rügen", "Germany")
cities[nrow(cities) + 1, ] <- c("Netherlands Antilles", "Netherlands")
cities[nrow(cities) + 1, ] <- c("Curaçao", "Netherlands")
cities[nrow(cities) + 1, ] <- c("Washington, D.C.", "United States")
cities[nrow(cities) + 1, ] <- c("Deep River", "Canada")
cities[nrow(cities) + 1, ] <- c("Harlem", "United States")
cities[nrow(cities) + 1, ] <- c("Christ Church", "New Zealand")
cities[nrow(cities) + 1, ] <- c("Demerara-Mahaica", "Guyana")
cities[nrow(cities) + 1, ] <- c("County Antrim", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Saint-Lin�???", "Canada")
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
cities[nrow(cities) + 1, ] <- c("Grande-Vallée", "Canada")
cities[nrow(cities) + 1, ] <- c("Poitou-Charentes", "France")
cities[nrow(cities) + 1, ] <- c("Hauterive", "France")
cities[nrow(cities) + 1, ] <- c("Pocé-sur-Cisse", "France")
cities[nrow(cities) + 1, ] <- c("Dartford", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Wrexham", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Staffordshire", "United Kingdom")
cities[nrow(cities) + 1, ] <- c("Katrineholm Municipality", "Sweden")
cities[nrow(cities) + 1, ] <- c("Northern Cyprus", "Cyprus")
cities[nrow(cities) + 1, ] <- c("Lefka", "Cyprus")
cities[nrow(cities) + 1, ] <- c("Rhône-Alpes", "France")
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
cities[nrow(cities) + 1, ] <- c("Hoyv�k", "Denmark")
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
cities[nrow(cities) + 1, ] <- c("Andaluc�?a", "Spain")


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
write.csv(artists_1, "../Data/artists_clean.csv")
