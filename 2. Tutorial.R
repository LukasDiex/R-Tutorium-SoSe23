rm(list=ls())
library(dplyr)


############## IDs erstellen und Datenfiles mergen ##########################

load("AT_CD_2013_small.RData")
load("AT_CH_2013_small.RData")
load("AT_CP_2013_small.RData")
load("AT_CR_2013_small.Rdata")

# create household IDs
aut_h$id_h <- paste(aut_h$HB020, aut_h$HB030, sep="") # hb020=Country, hb030=household ID
aut_d$id_h <- paste(aut_d$DB020, aut_d$DB030, sep="") # db020=Country, db030=household ID
aut_p$id_h <- paste(aut_p$PB020, aut_p$PX030, sep="") # pb020=Country, px030=personal ID
aut_r$id_h <- paste(aut_r$RB020, aut_r$RX030, sep="") # pb020=Country, rx030=personal ID
# create personal IDs
aut_p$id_p <- paste(aut_p$PB020, aut_p$PB030, sep ="")
aut_r$id_p <- paste(aut_r$RB020, aut_r$RB030, sep ="")

aut_hh <- right_join(aut_d, aut_h, by="id_h")
aut_indiv <- right_join(aut_r, aut_p, by = c("id_p" = "id_p", 
                                             "id_h" = "id_h"))
data <- right_join(aut_hh, aut_indiv, by = "id_h")
rm(aut_d, aut_h, aut_p, aut_r, aut_hh, aut_indiv)




################ gewichtete Regressionen + Dummy Variablen ####################

dataAT <- data %>% dplyr::select(id_p,PB040,PB140,PB150,PE040,PL060,PH010,PY010G) %>%
          rename(geburtsjahr=PB140,sex=PB150,Bildung=PE040,hours=PL060,health=PH010,income=PY010G)
rm(data)

#Atersvariable hinzufügen
dataAT$Alter <- 2013-dataAT$geburtsjahr

#Bildungsvariable ändern
library(forcats)
dataAT$Bildung <- as.factor(dataAT$Bildung)
fct_count(dataAT$Bildung)
# Faktorvariable mit 5 Level -> Achtung: andere Level im neueren SILC
# die wollen wir zu 3 Leveln zusammenfassen
dataAT$Bildung <- fct_collapse(dataAT$Bildung, Low = c("0", "1", "2"), Medium = c("3"), High = c("4","5"))
fct_count(dataAT$Bildung)

# automatisch dummies erstellen
# fuer alle variablen der klasse factor (und character) werden entsprechene dummies gebildet
library(fastDummies)
dataAT$sex <- as.factor(dataAT$sex)
dataAT$health <- as.factor(dataAT$health)
dataAT <- fastDummies::dummy_cols(dataAT, select_columns = c("sex", "health"), remove_first_dummy = T)
str(dataAT)

#Ein survey design object erstellen
library(survey)
surveydesign <- svydesign(ids = dataAT$id_p, weights = dataAT$PB040, data = dataAT, na.rm = T)

#Regression
mod <- svyglm(income ~ sex_2 + Bildung + hours + health_2 + health_3 + health_4 + health_5, 
                data = dataAT, 
                design = surveydesign)
summary(mod)
# FÜr sex und health haben wir mit dem fastDDummies package automatisch Dummies erstellt
# Der Bildungsvariable haben wir nur neue Levels versehen, aber keine Dummies erstellt. R streicht aber automatisch ein Level,
# um Multikollinearität zu verhindern.




##################### Gini und Lorenzkurve ##########################

library(acid) # package für u.a. gewichteten Gini, Lorenzkurven, etc.
weighted.gini(dataAT$income, w = dataAT$PB040)$Gini

library(REAT) #package für u.a. gewichtete Lorenzkurven
lorenz(dataAT$income, weighting = dataAT$PB040, z = NULL, na.rm = TRUE,
       lcx = "% of population", lcy = "% of employee cash or near cash income", 
       lctitle = "Lorenz curve", le.col = "blue", lc.col = "black",
       lsize = 1.5, ltype = "solid", bg.col = "gray95", bgrid = TRUE, 
       bgrid.col = "white", bgrid.size = 2, bgrid.type = "solid",
       lcg = FALSE, lcgn = FALSE, lcg.caption = NULL, lcg.lab.x = 0, 
       lcg.lab.y = 1, add.lc = FALSE, plot.lc = TRUE)




#################### progressive Steuern + Steuerlast ###########################
#Funktion die besagt wie die Einkommenssteuer berechent wird
Einkommenssteuer <- function(income,
                             brackets = c(10000, 25000, 50000, 100000, Inf),
                             rates = c(0, .15, .25, .35, .45)) {        
  sum(diff(c(0, pmin(income, brackets))) * rates)
}

#anwenden der Funktion auf den Datensatz, die neue Variable gibt die Steuerlast je Person an
dataAT$Steuerlast <- mapply(Einkommenssteuer, dataAT$income)
