# always load your packages at the beginning of your script. You only need to
# activate the package once per sessions. Also, if you are working in a team
# your colleagues will get a better overview. 
library(openxlsx)
library(dplyr)
library(ggplot2)

## Read Data ##
# if you always save your data in the same path as the project, you can easily
# access the data, without specifying the full path. and, again this is good
# for sharing work, as you only have to copy the project's folder:
df <- read.xlsx("example.xlsx")
# obviously you could still use the full path. Note, that you need to change \ to /
df_1 <- read.xlsx("C:/Users/diexl/Documents/Unijob/WU Department/Tutor WiPol/R Tutorium/R-Tutorium-SoSe23/example.xlsx")
# if you need a specific sheet of your excel-file use: (this is only an example)
df_2 <- read.xlsx("data/example.xlsx", sheet = "Sheet2")
# read CSV-files:
# this will be our practice file: it contains data on daily covid numbers in
# Austria. The data starts on 26.02.2020 and ends on 03.05.2021. We will 
# have a closer look on what data is contained within the dataset, manipulate
# it and do some descriptives. 
df <- read.csv("ts_covid_sortiert.csv", sep = ";")
# getwd gets you your current working directory so you can check where your files
# are saved. use setwd() to change your current working directory.
getwd()
# within the brackets you should specify the link to your directory.
setwd()

## Data Cleaning ##
### have a first look at the data ###
# use View() to open a new tab with your data table, or click on it in the 
# environment
View(df)
# get column names
colnames(df)
# have a look at the structure of your data. Note that this is the same as the
# information in your environment
str(df)
# get a summary for each column
summary(df)
# have a look at the first few rows
head(df)

# scatter plot: why is there such a gap in between the points?
plot(df$AnzahlFaelleSum)
wien <- subset(df, GKZ == 900)
plot(as.ts(wien$AnzahlFaelleSum), lwd=2, col = "red")

# frequency distribution of numerical vectors
# you can also check via histogram
hist(df$AnzahlFaelle)
hist(df$AnzahlFaelle, breaks = "sturges")
hist(df$AnzahlFaelle, breaks = "fd")
hist(df$AnzahlFaelle, breaks = 3)
hist(df$AnzahlFaelle, breaks = 100)
# now we want to get rid of the time dimension. Therefore, we extract the day
# when the covid-incidence was the highest
# first we need to find out which day this is. max() gives you the highest 
# covid-incidence contained in the data.
max_value <- max(df$SiebenTageInzidenzFaelle)
# now we use the returned value to subset our dataset. [,] this kind of brackets
# accesses the dataframe. Entries before the comma refer to the rows of your
# dataframe, whereas after the comma refer to the column. Think of this code 
# line as: subset the data at the row where "SiebenTageInzidenzFaelle" equals
# our max()-value and also return the corresponding column entries for Time and
# district.
max_date <- df[df$SiebenTageInzidenzFaelle == max_value, 
               c("Time", "Bezirk", "SiebenTageInzidenzFaelle")]
max_date
# now we know that on the 07.11.2020 Eferding had the highest covid incidence 
# in our observation period. therefore, we now get rid of the time dimension
# by extracting this day.
data_1 <- subset(df, Time == "2020-11-07")
head(data_1)
# however, we no longer care about the Time-column and we also do not need the
# number of people who have recovered. (look at the changes in your
# envrionment). Also, note that instead of using the subset()-function we
# directly adressed the index of the columns of interest.
data_2 <- df[,-c(1, 12)]
head(data_2)
# however, we could have done this more efficiently
data <- subset(df, Time == "2020-11-07", select = c("Bezirk", "GKZ",
                                                    "AnzahlFaelle",
                                                    "AnzahlFaelleSum",
                                                    "SiebenTageInzidenzFaelle",
                                                    "AnzahlTotTaeglich",
                                                    "AnzahlGeheiltSum"))
head(data)
# You might also see a different type of "coding": the dplyr-version. "dplyr" is
# a package designed for data manipulation which uses tubes (%>%). In most cases
# it does the same thing. However, the subset()-function sometimes struggles 
# with large datafiles - more than a million entries. The dplyr-package seems to
# be able to handle this better.
?dplyr
# now follow the instructions of the description: enter 
# "browseVignettes(package = "dplyr")" into your console. Your browser will 
# open and display a help page. Choose "introduction to dplyr" and open the 
# R-code version. Here you get usefull advice on how to handle the package.
data <- data %>% select(Bezirk, GKZ, AnzahlFaelle, AnzahlFaelleSum,
                        SiebenTageInzidenzFaelle, AnzahlTotTaeglich)
head(data)
# when looking at the data, we can also see that the incidence uses decimal 
# values with a comma instead of a point. we need to change this in order to 
# use the variable
data$SiebenTageInzidenzFaelle <- gsub(",",".", data$SiebenTageInzidenzFaelle)
# you can also combine tubes
data <- data %>% select(Bezirk, GKZ, AnzahlFaelle, AnzahlFaelleSum, 
                        SiebenTageInzidenzFaelle) %>% rename(Inzidenz =
                                                               SiebenTageInzidenzFaelle)

head(data)
barplot(data$AnzahlFaelle)
# now lets brush up the plot
barplot(data$AnzahlFaelle, names.arg = data$Bezirk, ylab = "Anzahl positiver Fälle am Stichtag")
par(las = 2)
# now lets add some color to the bars, according to the respective counties of 
# the districts
colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22")
country_indicator <- substr(df$GKZ, 1, 1)
bar_colors <- colors[as.integer(country_indicator)]
barplot(data$AnzahlFaelle, names.arg = data$Bezirk, ylab = "Anzahl positiver Fälle am Stichtag", col = bar_colors, border = NA, space = 0.5)


################################################################################
## using EU-SILC
load("AT_CD_2013_small.RData")
load("AT_CH_2013_small.RData")
load("AT_CP_2013_small.RData")
load("AT_CR_2013_small.Rdata")






