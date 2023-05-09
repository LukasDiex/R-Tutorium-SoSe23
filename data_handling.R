# always load your packages at the beginning of your script. You only need to
# activate the package once per sessions. Also, if you are working in a team
# your colleagues will get a better overview. 
library(openxlsx)
library(dplyr)
library(ggplot2)
library(doBy)

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

p_data<-aut_p %>% rename(pid=PB030)
p_register<-aut_r %>% rename(pid=RB030, hhid=RX030)
hh_data <- aut_h %>% rename(hhid=HB030)
hh_register <- aut_d %>% rename(hhid=DB030)
# now check if there are rows in your data that do not match with the other data file
testjoin <- p_data %>% anti_join(p_register, by="pid")
# as there are no non-matches, we can simply merge
p_data <- p_register %>% left_join(p_data, by="pid")
h_data <- hh_register %>% left_join(hh_data,by="hhid")
# lets also add the household data to the file
data <- p_data %>% left_join(h_data, by="hhid")
# remove original files
rm(aut_d, aut_h, aut_p, aut_r, testjoin, p_register, p_data, hh_data, hh_register, h_data)
# now lets get a subset
data.temp <- data %>% select(pid, hhid, RB080, RB090, PB210, PE040, PL031, HY020, HS120, HX040, DB090,PB040) %>%
  rename(birthyear=RB080, gender=RB090, birthcountry=PB210, educ=PE040, economicstatus=PL031,
         hh_income=HY020, makeendsmeet=HS120, hh_size=HX040, hh_weight=DB090, p_weight=PB040)
View(data.temp)
# how to get an age variable
data.temp$age <- 2013-data.temp$birthyear

#Inspecting the data set 
str(data.temp)
glimpse(data.temp)
head(data.temp)
dim(data.temp) # number of observations
is.na(data.temp)
data.temp <- data.temp[complete.cases(data.temp[ , 11:12]),]

# How many persons are represented by the sample?
# Sum up individual weights
n.pop <- sum(data.temp$p_weight) #number of individuals

#counted with household weights
n.pop.h <- sum(data.temp$hh_weight) #number of individuals

n.pop;n.pop.h
# Note: institutional households (prisons, boarding schools, homes for the elderly, etc.) and homeless people are excluded

# How many women / men are in the data set?
# rb090: 1 - male, 2 - female
table(data.temp$gender)

# Using individual survey weights: how many men/women do these data represent?
sum((data.temp$gender == 1)*data.temp$p_weight)
sum((data.temp$gender == 2)*data.temp$p_weight)

#alternative based on dplyr
males <- data.temp %>% filter(gender == 1) %>% 
  mutate(population = gender * p_weight) %>%
  summarise(males.in.pop = sum(population))
males

##for males and females at same time
pop.by.gender <- data.temp %>%
  group_by(factor(gender)) %>%
  summarise(population = sum(p_weight)) 
pop.by.gender
# Calculate the share of women in the population. 
n.fem.pop <- sum((data.temp$gender==2) * data.temp$p_weight) 
share.fem.pop <- n.fem.pop / n.pop
share.fem.pop
# Calculate the share of women in the sample.
n <- nrow(data.temp)
n.fem.sample <- sum(data.temp$gender==2)
share.fem.sampl <- n.fem.sample / n
share.fem.sampl

# Calculate summary statistics for education
# pe040: highest education obtained

#0 pre-primary education
#1 primary education
#2 lower secondary education
#3 (upper) secondary education
#4 post-secondary non tertiary education
#5 first stage of tertiary education (not leading directly to an advanced research qualification)
#6 second stage of tertiary education (leading to an advanced research qualification)

summary(data.temp$educ) 
table(data.temp$educ)

out <- summaryBy(p_weight ~ educ, data=data.temp, FUN=sum) 
print(out)

out$share <- out$p_weight.sum/n.pop*100
sum(out$share)

barplot(out$share)
barplot(out$share, names.arg = c("Pre-Primary", "Low. Second", "Second", "Post Second","Tertiary"),
        ylab="% of Population",  ylim=c(0,50), main = "Education", col = "firebrick")

coul <- RColorBrewer::brewer.pal(5, "Set2") 
barplot(out$share, 
        names.arg = c("Pre-Primary", "Low. Second", "Second", "Post Second", "Tertiary and higher"),
        ylab="% of Population",  
        ylim=c(0,50), 
        main = "Education", 
        col = coul)

# Plot shares for sex 
# Use pb150=gender: 1 - male, 2 - female
out.gender <- summaryBy(p_weight ~ gender, data = data.temp, FUN = sum)
out.gender$share <- out.gender$p_weight.sum/n.pop*100

out.gender <- data.frame(out.gender)

barplot(out.gender$share)
barplot(out.gender$share, names.arg=c("Males", "Females"), 
        ylab="% Per Cent", main="Gender", col="firebrick")

##with ggplot
values <- c("#999999", "#E69F00")
lab <-c("Males", "Females")

ggplot(data = out.gender, aes(x = factor(gender), y = share, fill = factor(gender))) +
  geom_bar(stat = "identity") +
  scale_x_discrete("Gender") +
  scale_y_continuous("Per Cent") +
  scale_fill_manual("Pop by Gender", values = values, labels = lab)







##########################################################################################






