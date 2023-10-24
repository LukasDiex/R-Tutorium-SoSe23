# always load your packages at the beginning of your script. You only need to
# activate the package once per sessions. Also, if you are working in a team
# your colleagues will get a better overview. 
library(openxlsx)
library(dplyr)
library(ggplot2)
library(doBy)
library(convey)
library(survey)
## Read Data ##
# if you always save your data in the same path as the project, you can easily
# access the data, without specifying the full path. and, again this is good
# for sharing work, as you only have to copy the project's folder:
df <- read.xlsx("example.xlsx")
# obviously you could still use the full path. Note, that you need to change \ to /
df_1 <- read.xlsx("C:/Users/diexl/Documents/Unijob/WU Department/Tutor WiPol/R Tutorium/R-Tutorium-SoSe23/example.xlsx")
# if you need a specific sheet of your excel-file use: (this is only an example)
df_2 <- read.xlsx("data/example.xlsx", sheet = "Sheet2")
# getwd gets you your current working directory so you can check where your files
# are saved. use setwd() to change your current working directory.
getwd()
# within the brackets you should specify the link to your directory.
setwd()
# read CSV-files:
# this will be our practice file: it contains data on daily covid numbers in
# Austria. The data starts on 26.02.2020 and ends on 03.05.2021. We will 
# have a closer look on what data is contained within the dataset, manipulate
# it and do some descriptives. 
df <- read.csv("ts_covid_sortiert.csv", sep=";")
str(df$SiebenTageInzidenzFaelle)
df$SiebenTageInzidenzFaelle <- gsub(",",".", df$SiebenTageInzidenzFaelle)
df$SiebenTageInzidenzFaelle <- as.numeric(df$SiebenTageInzidenzFaelle)
# alternatively you can also use the dplyr package
df <- df %>%
  mutate(SiebenTageInzidenzFaelle = as.numeric(gsub(",", ".", SiebenTageInzidenzFaelle)))
str(df$SiebenTageInzidenzFaelle)

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
# now we know that on the 12.11.2020 Rohrbach had the highest covid incidence 
# in our observation period. therefore, we now get rid of the time dimension
# by extracting this day.
data_1 <- subset(df, Time == "2020-11-12")
head(data_1)
# however, we no longer care about the Time-column and we also do not need the
# number of people who have recovered. (look at the changes in your
# envrionment). Also, note that instead of using the subset()-function we
# directly adressed the index of the columns of interest.
data_2 <- data_1[,-c(1, 12)]
head(data_2)
# however, we could have done this more efficiently
data <- subset(df, Time == "2020-11-12", select = c(2:10))
# or equivalently using dplyr
data <- df %>%
  filter(Time == "2020-11-12") %>%
  select(2:10)
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

# when looking at the data, we can also see that the incidence uses decimal 
# values with a comma instead of a point. we need to change this in order to 
# use the variable
# you can also combine tubes
rm(list = ls())
df <- read.csv("ts_covid_sortiert.csv", sep=";")
data <- df %>% filter(Time == "2020-11-12") %>%
               select(Bezirk, GKZ, AnzEinwohner, AnzahlFaelle, AnzahlFaelleSum, 
                        SiebenTageInzidenzFaelle) %>% 
               rename(Inzidenz = SiebenTageInzidenzFaelle) %>%
               mutate(Inzidenz = as.numeric(gsub(",", ".", Inzidenz)))
head(data)     
                  
barplot(data$Inzidenz)
# now lets brush up the plot
barplot(data$Inzidenz, names.arg = data$Bezirk, ylab = "Anzahl positiver Fälle am Stichtag")
par(las = 2)
# now lets add some color to the bars, according to the respective counties of 
# the districts
colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22")
country_indicator <- substr(df$GKZ, 1, 1)
bar_colors <- colors[as.integer(country_indicator)]
barplot(data$Inzidenz, names.arg = data$Bezirk, ylab = "Anzahl positiver F?lle am Stichtag", col = bar_colors, border = NA, space = 0.5)

# now lets do a scatterplot with the number of inhabitants of a district
# and the number of positively tested persons
scatter.smooth(data$AnzahlFaelle, data$AnzEinwohner)
# Vienna appears to be an outlier, what if we exclude Vienna?
data_novie <- data[-94,]
scatter.smooth(data_novie$AnzahlFaelle, data_novie$AnzEinwohner, 
               family = "gaussian", xlab = "Anzahl positiv getester Personen",
               ylab="Anzahl Einwohner*innen", lpars=list(col="red", lwd=3, lty=1))
################################################################################
rm(list = ls())
## using EU-SILC
# these are sample files for Austria in 2013. These are not official data from
# the EU-SILC and are therefore not representative for any kind of population.

# EU-SILC uses 4 different datasheets. Regarding observations on the individual 
# level, you get the "p" and "r" file. P contains data on individual's income,
# sociodemographic background and so on. R contains more technical data. The same
# goes for observations on the household level. There the files are called "d"
# and "h".
load("AT_CD_2013_small.RData")
load("AT_CH_2013_small.RData")
load("AT_CP_2013_small.RData")
load("AT_CR_2013_small.Rdata")

# go to https://www.gesis.org/en/missy/metadata/EU-SILC/2013/Cross-sectional/original
# EU-SILC is one of the best documented surveys available, especially on a
# cross-country level. This homepages provides documentation on the survey-procedure
# the variables included and an overview of the variable's values.

## Merging Data
# First, we want to create unique ID-variables as they might be used elsewhere for
# another country (in case you are working with the actual cross-country EU-SILC data)
# create household IDs
aut_h$id_h <- paste(aut_h$HB020, aut_h$HB030, sep="") # hb020=Country, hb030=household ID
aut_d$id_h <- paste(aut_d$DB020, aut_d$DB030, sep="") # db020=Country, db030=household ID
aut_p$id_h <- paste(aut_p$PB020, aut_p$PX030, sep="") # pb020=Country, px030=personal ID
aut_r$id_h <- paste(aut_r$RB020, aut_r$RX030, sep="") # pb020=Country, rx030=personal ID
# create personal IDs
aut_p$id_p <- paste(aut_p$PB020, aut_p$PB030, sep ="")
aut_r$id_p <- paste(aut_r$RB020, aut_r$RB030, sep ="")
# now we can merge the two household files
# first we check for observations that are contained in one of the dataframes, but
# not in the other
testjoin_hh <- anti_join(aut_d, aut_h, by="id_h")
testjoin_hh
aut_hh <- right_join(aut_d, aut_h, by="id_h")
# now we can merge the two household files
testjoin_p <- anti_join(aut_r, aut_p, by = c("id_p" = "id_p", 
                                             "id_h" = "id_h"))
# we can see that the register file contains more observations than the data file.
# this is due to the fact that not every interview was completed succesfully. So,
# individuals might appear in the register file, but have no data.
# now merge the personal file
aut_indiv <- right_join(aut_r, aut_p, by = c("id_p" = "id_p", 
                                             "id_h" = "id_h"))
# Finally, we can merge the houeshold file with the individual file
data <- right_join(aut_hh, aut_indiv, by = "id_h")
#now we can remove the other data files
rm(aut_d, aut_h, aut_p, aut_r, aut_indiv, testjoin_hh, testjoin_p)
View(data)
# now lets get a subset
# in order to get a better overview of what we are doing, we are renaming the variables as the acronyms can get confusing. If you need to
# look for variable names, always get back to the MISSY-homepage
data.temp <- data %>% select(id_p, id_h, RB080, RB090, PB210, PE040, PL031, HY020, HS120, HX040, DB090,RB050, DB040, PY010G, PL040, PL060, DB020, HX090, HH050) %>%
  rename(birthyear=RB080, gender=RB090, birthcountry=PB210, educ=PE040, economicstatus=PL031,
         hh_income=HY020, makeendsmeet=HS120, hh_size=HX040, hh_weight=DB090, p_weight=RB050, region=DB040, country=DB020, p_income=PY010G, emp_status=PL040,
         h_worked_week=PL060, arp=HX090, warm=HH050)
View(data.temp)
# how to get an age variable
data.temp <- data.temp %>%
  mutate(age = 2013 - birthyear)

#Inspecting the data set 
str(data.temp)
glimpse(data.temp)
head(data.temp)
dim(data.temp) # number of observations
is.na(data.temp)
data.temp <- na.omit(data.temp)
View(data.temp)
sum(is.na(data.temp))

## Check your sample
# How many persons are represented by the sample?
# Sum up individual weights
n.pop <- sum(data.temp$p_weight) #number of individuals
#counted with household weights
n.pop.h <- sum(data.temp$hh_weight) #number of individuals
n.pop;n.pop.h
# Note: institutional households (prisons, boarding schools, homes for the elderly, etc.) and homeless people are excluded

# How many women / men are in the sample?
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

out <- data.temp %>%
  group_by(educ) %>%
  summarise(pop = sum(p_weight))
out
out$share <- out$pop/n.pop*100
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
out.gender <- data.temp %>%
  group_by(gender) %>%
  summarise(pop = sum(p_weight))
out.gender
out.gender$share <- out.gender$pop/n.pop*100
barplot(out.gender$share)
barplot(out.gender$share, names.arg=c("Males", "Females"), 
        ylab="% Per Cent", main="Gender", col="firebrick")

##with ggplot
values <- c("#999999", "#E69F00")
lab <-c("Males", "Females")

ggplot(data = out.gender, aes(x = factor(gender), y = share, fill = factor(gender))) +
  geom_bar(stat = "identity") +
  scale_x_discrete("Gender") +
  scale_y_continuous("Percent") +
  scale_fill_manual("Pop by Gender", values = values, labels = lab)

rm(males, out, out.gender, pop.by.gender, coul, lab, n, n.fem.pop, n.pop, n.fem.sample,
   n.pop.h, share.fem.pop, share.fem.sampl, values)

# now lets create a survey design
# survey designs are needed for performing regressions and other operations, as 
# we deal with survey data which needs to be weighted in order to representative
# for the overall population
?svydesign
# survey design for individual level operations
data.temp <- data.temp %>% filter(p_income > 0)
data.pd.svy <- svydesign(ids = ~ id_p, strata = ~region,
                         weights = ~ p_weight,
                         data = data.temp) %>% convey_prep()
# survey design for household level operations
data.hd.svy <- svydesign(ids = ~ id_h, strata = ~region,
                         weights = ~ hh_weight,
                         data = data.temp) %>% convey_prep()

###Survey Lorenz Kurve
lorenz <- svylorenz(~hh_income, design = subset(data.hd.svy, !is.na(hh_income)),
          quantiles = seq(0,1,0.1),
          alpha = 0.05,
          curve.col = "red")
#Histogram
svyhist(~hh_income, design = data.hd.svy, main = "Adjustable household income in AT 2013",
        col = "deeppink4", breaks = 100)
svyhist(~hh_income, design = subset(data.hd.svy, hh_income <75000),
        main = "Adjustable household income in AT 2013",
        col = "deeppink4",
        breaks = 75,
        xlab = "wage level", ylab = "density mass")
lines(svysmooth(~hh_income,
                design = subset(data.hd.svy, hh_income > 0 & hh_income < 75000)),
      lwd = 2, col = "gray") 

# Mean in groups
tab.inc <- svyby(~p_income, ~gender + educ, 
                 design = subset(data.pd.svy, p_income > 0),
                 svymean)
barplot(tab.inc)
tab.inc <- tab.inc[order(tab.inc$educ),]
barplot(tab.inc)
legend("topleft", c("Male", "Female"),
       fill = c("black", "gray"), cex = 1, ncol = 2)

## Regressions
# first we create the subsample we need for the regression
data.reg <- data.temp %>% filter(emp_status == 3,
                              h_worked_week > 0) %>%
  mutate(hwages = p_income / ((h_worked_week)*52))%>%
  mutate(gender = factor(gender, labels = c('Male','Female')))

# to see the difference, we first do the regression without the survey design
nonsvyols <- lm(hwages ~ age + gender, data = data.reg)
# now we use the surveydesign
reg.pd.svy <- svydesign (ids = ~ id_p, strata = ~region,
                          weights = ~p_weight, data = data.reg) %>%
  convey_prep()
svyols <- svyglm(hwages ~ age + gender, design = reg.pd.svy)

summary(svyols)
summary(nonsvyols)

par(mfrow = c(1, 2))
hist(svyols$residuals)
hist(nonsvyols$residuals)

## Median and Quantiles
# Median
svyquantile(~p_income, data.pd.svy, quantile = c(0.5), na.rm=TRUE)

svyby(~p_income, by=~country, 
      design = data.pd.svy, FUN = svyquantile,
      quantiles=c(0.25, 0.5, 0.75), ci = TRUE)

median_wage_gender<- svyby(~p_income, 
                           ~gender, design = data.pd.svy,
                           svyquantile, quantiles = 0.5, ci=TRUE, 
                           include.lowest=TRUE)
# Mean
svymean(~hh_income, design = data.hd.svy)
svyby(formula = ~hh_income, by =~country, 
      design=data.hd.svy, FUN=svymean)
# Deciles
svyquantile(~p_income, data.pd.svy, quantile = seq(0, 1,by = 0.1),
            method = "linear", ties = "rounded", na.rm=TRUE)


##generieren von 5 'klassen' der lohnverteilung
#cdf speichern
cdfs<-svycdf(~p_income, data.pd.svy) #function abspreichern
#zb cdf an stelle 1.000 abrufen: 
cdfs[[1]](1000)#
cdfs[[1]](c(1000,3000)) #6 - 14 % der löhne liegen zwischen 1.000 und 3.000 euro

#im design speichern
data.pd.svy <- update(data.pd.svy,
                            cdf_wages=cdfs[[1]](p_income))
#abrufen 
data.pd.svy$variables$cdf_wages

#in gruppen umcodieren:
data.pd.svy<-update(data.pd.svy, 
                           cdf_wages_100=ceiling(cdf_wages*100))
data.pd.svy$variables$cdf_wages_100
data.pd.svy<- update(data.pd.svy,
                            income_class=cut(cdf_wages,
                                             c(0,0.5,0.9,0.99,1),
                                             labels=c('bottom 50', 'middle class', 'upper class', 'Top 1%')))
data.pd.svy$variables$income_class


#one continous variable
#add a count variable
data.hd.svy <- update(data.hd.svy, count=1)
svytotal(~count,data.hd.svy)

cdf.wage <- svycdf(~p_income, data.pd.svy)

cdf.wage.wowgt <- ecdf(data.temp$hh_income)
plot(cdf.wage, do.points=FALSE, xlab = "Wage Income", 
     ylab = "Cdf")
plot(cdf.wage, do.points = FALSE, xlab = 
       "Wage Income", ylab = "cdf", 
     main = "cdf Wag Inc AT", xlim = c(0,4*10^5))

lines(cdf.wage.wowgt, do.points = FALSE, lwd = 2, 
      col = "red" )
legend("bottomright", bty = "n", fill = c("black", "red"), 
       legend = c("weighted", "unweighted"))

##histogram:
svyhist(~p_income, design = data.pd.svy, 
        main = "histogram Wage Income", 
        col ="gray", xlab = "Wage Income")
svyhist(~p_income, design = subset(data.pd.svy, p_income < 150000), 
        main = "hist wage", col = "gray", xlab = "inc wage")
lines(svysmooth(~p_income, subset(data.pd.svy, p_income < 150000)), 
      lwd = 2)        

# Boxplot
svyboxplot(p_income~as.factor(educ), data.pd.svy,
           main = "Boxplot Wage Income",
           col = "gray", ylab = "Wage Income", xlab="Educ-Groups")


# Sonderbefragung: Frankreich nicht auffindbar

