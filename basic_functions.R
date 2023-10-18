rm(list = ls())

################################################################################

## some basic functions
x <- c(1,3,4,6.6,8,1) # create vector
# sort vector, note that the default here is an increasing order
sort(x)
# how to get a decreasing order?
?sort 
sort(x, decreasing = TRUE)
# length of object
length(x)  
# numeric maximum of vector
max(x) 
# numeric minimum of vector
min(x) 
# unique values in vector
unique(x) 
length(unique(x))
# frequency table of vector
table(x) 
# simple plot with index on x-axis and values on y-axis
plot(x) 
# summarise info on object, output depends on object!
summary(x) 
# print object to console
print('Hello world') 
# round value, second argument gives decimal place
round(3.5467)
round(3.5467, digits = 3) 
# create sequence of numbers
seq(from=1, to=10, by=3) 
# get information on functions
?seq 
# You do not need to type in the arguments' names if you know their
# position
seq(1,10,2) 
# repeat a vector
rep(c(8,6,4,2), each = 2)
rep(c(8,6,4,2), times = 2)
# sqaure root of something
sqrt(16)
#sine
sin(pi/2)
#cosine
cos(0)  
#tangent
tan(0)  
#natural logarithm
log(6)
#e^x
exp(1)        
#next higher integer
ceiling(1.2) 
#next lower integer
floor(1.2) 
#absolute value
abs(-1)   
# structure of an object 
str(x)   
# class or type of an object
class(x)
# combine objects as columns
y <- seq(1:6)
cbind(x, y) 
# combine objects as rows 
rbind(x, y) 

################################################################################

## character functions
#returns string of uppercase letters
toupper("Test")
#returns string of lowercase letters
tolower("Test")  
#returns string from start to stop
substr("Test", start=2, stop=3)    
#splits string given the split character
strsplit("Test", split="")          
strsplit("Test", split="e")
#combines strings with given separator
paste("T", "e", "s", "t", sep="")   

################################################################################

## boolean / logical values
TRUE
FALSE
# can be used in arithmetic operations (T is 1, F is 0)
sum(c(TRUE, TRUE, FALSE))
c(TRUE, TRUE, FALSE) * 2 + c(3,4,pi)
# TRUe and FALSE are fixed values in R -> case sensitive!
TRUE <- 'something else' # Doesn't work
True <- 'something else' # Does work
# WARNING do not use "T" <- 'something else' as this is the abbreviation of TRUE
 
################################################################################

## basic logical operators
5 == 10 # YOU NEED to Use "==" NOT "="
5 != 10
5 > 10
5 < 10
5 >= 10
5 <= 10
# order does not matter
c(1,2,3,4,5) == 3
3 == c(1,2,3,4,5)

################################################################################

## compare multiple expressions
# logical "and"
FALSE & FALSE
FALSE & TRUE
TRUE & TRUE
# logical "or"
FALSE | FALSE 
FALSE | TRUE
TRUE | TRUE
# examples
(1<5) & (2<10) 
(c(1,3,5)>1) & (5==c(1,3,5))
# and one more operator (order matters!)
3 %in% c(1,3,5)
c(1,3,5) %in% 3

################################################################################

#Statistical probability functions
#generates 1 random number from the standard normal distribution
rnorm(1,0,100)       
#normal density function  - probability density function (PDF)                    
dnorm(1,0,1)
x <- seq(from = -5, to = 5, by = 0.05)
rnorm(x)
dnorm(x)
# you can also plot the distribution graphically
library(ggplot2)
norm_dat <- data.frame(x = x, pdf = dnorm(x))
ggplot(norm_dat) + geom_line(aes(x = x, y = pdf))
#cumulative normal probability - cumulative distribution function (cdf)
pnorm(0)
#normal quantile (value at the p percentile of normal distribution))
qnorm(0.8)     
#r-, d-, p-, q- always evoke the above described commands for a given 
#distributen. Other distributions may vary in their parametrization.

#commonly used distributions:
#Normal:    -norm
#Uniform:   -unif
#Beta:      -beta
#gamma:     -gamma
#Binomial:  -binom
#Poisson:   -pois
#Weibull:   -weibull

################################################################################

## Other statistical functions
x <- seq(1:10)

#arithmetic mean
mean(x)
#variance
var(x)  
#standard deviation = same as sqrt(var(x))
sd(x)	  
#median
median(x)	
#quantiles (quartiles on default)
quantile(x)	
#range
range(x)
#sum
sum(x)	
#minimum
min(x)	
#maximum
max(x)	        

################################################################################

## if you need a dice, create one
# create a object "dice" that has values 1, 2, 3, 4, 5, 6 (a vector)
dice <- 1:6  
#substract 1 from each element
dice-1    
#divide each element by 2
dice/2    
#multiplicate each row 
dice*dice   
#inner matrix multiplication
dice%*%dice   
#outer matrix multiplication
dice%o%dice   

################################################################################

## if else statements
# if
if() {
# else if
} else if() {
# else  
} else() {
  
}







# example
if(9 < 10) {print('This happens')}
if(9 > 10) {print('This does not happen')}

# a simple game of dice:
player_1 <- sample(1:6, 1)
player_2 <- sample(1:6, 1)
# thik of this in verbal terms. If player1 rolled a higher number than player2,
# then write: player1 wins.
if(player_1 > player_2) {           
  
  print('player_1 wins')
# But, if player2 rolled the higher number, then write player2 wins.  
} else if (player_1 < player_2) {
  
  print('player_2 wins')
# Otherwise, they must have rolled the same number, thats the only possible
# outcome left. In this last case left write that both win.
# note that it is important that the "else" statement comes at the same line
# as the closing bracket } of the if part
} else {
  
  print('everybody wins')
  
}
# recall the example of the pq-formula from the "basics.R"-file
p <- 6
q <- 5

under_square_root <- (p/2)^2 - q

if(under_square_root > 0) {
  
  print( - p/2 + sqrt(under_square_root))
  print( - p/2 - sqrt(under_square_root))
  
} else if (under_square_root == 0) {
  
  print(-p/2)
  
} else {
  
  print('No real solution for this one..')
  
}

################################################################################

## Loops
# In R you have multiple options when repeating calculations: vectorized 
# operations, loops and apply functions.
# while loops:
# these loops are similar to the if statement. it executes the code inside if
# the condition is true. However, the while loop executes the code over and 
# over again, as long as the condition is true.

while(condition) {  # if this condition holds
  expr              # what do we want the while loop to do on every iteration
}

# example:
count <- 1
while(count <= 7) {
  print(paste("count is set to", count))
  count <- count+1
}
# note that we have two expressions in this example. one tells the loop what to
# print. and the other increments the count variable to prevent the loop from
# running endlessly.
count

# break statement:
# the break statement simply breaks out of the while. in this example we want
# the break statement to activate as soon as count reaches a level divisible
# by 5
count <- 1
while(count <=7) {
  if(count %% 5 ==0){
    break
  }
  print(paste("count is set to", count))
  count <- count+1
}
count

# for loops:
# for each variable in a sequence, run the following expression
for(var in seq) {
  expr
}
# example
cities <- c("Turin", "Barcelona", "London", "Paris", "Havanna",
            "Wien", "Mexico City", "Hongkong", "Hamburg")
cities

for(city in cities){
  print(city)
}
city
# note that the for loop automatically identifies "cities" as a sequence, 
# containing different variables. Each city is a value of this sequence. 
# Here, we told R to print every variable of the sequence separately.
# the for loop also works with lists:
cities <- list("Turin", "Barcelona", "London", "Paris", "Havanna",
            "Wien", "Mexiko City", "Hongkong", "Hamburg")
cities

for(city in cities){
  print(city)
}
city

# break-statement also works with foor loops
for(city in cities){
  if (nchar(city) == 6) {
    break
  }
  print(city)
}
# the break statement stops the loop as soon as it encounters a name with
# character length being equal to 6. In this case London, which is no longer
# printed out.

# you can also use the "next" statement
for(city in cities){
  if(nchar(city) == 6){
    next
  }
  print(city)
}

# the next statement skips those entries violating our if condition and
# proceeds to the next iteration

## advanced looping
# additionally to print out the city name, we also want to have information on
# the variables' position inside the vector. Therefore, we need to adapt the
# "looping index". This index is the counter R uses behind the scenes to know 
# which element to select on every iteration. 
# Now instead of iterating over the cities, we will manually create the index.
cities <- list("Turin", "Barcelona", "London", "Paris", "Havanna",
               "Wien", "Mexiko City", "Hongkong", "Hamburg")
cities

for(i in 1:length(cities)) {
  print(cities[i])
}

################################################################################

## the apply family
# lapply
vienna <- list(pop = 1982442, districts = c("Innere Stadt, Leopoldstadt",
                                         "Landstraße", "Wieden", "Margareten",
                                         "Mariahilf", "Neubau", "Josefstadt",
                                         "Alsergrund", "Favoriten", "Simmering",
                                         "Meidling", "Hietzing", "Penzing",
                                         "Rudolfsheim-Fuenfhaus", "Ottakring",
                                         "Hernals", "Waehring", "Doebling",
                                         "Brigittenau", "Floridsdorf", 
                                         "Donaustadt", "Liesing"),
            capital = TRUE)
# now we want to get information of the different variables included in the
# list. This could be done by a for loop
for(info in vienna) {
  print(class(info))
}
# or you just use the lapply function
lapply(vienna, class)
# lapply iterated over the whole list and for each entry in the list, it
# applied the class function
# now, if you want to find out the length of characters of a city name, you can
# again use a for loop
num_chars <- c()
for(i in 1:length(cities)) {
  num_chars[i] <- nchar(cities[i])
}
num_chars
# or you simply use the lapply function
lapply(vienna, nchar)
# create your own function and apply it with lapply
oil_prices <- list(2.37, 2.49, 2.18, 2.22, 2.47, 2.32)
multiply <- function(x, factor) {
  x*factor
}
result <- lapply(oil_prices, multiply, factor =3)
result
unlist(result)
result_unlist <- unlist(result)
result_unlist
str(result)
str(result_unlist)
# sapply
# sapply is short for simplified apply function. look at the output in your
# console compared to the lapply function
# what happens in the background is that sapply calls on lapply but also uses
# "simplify to array"-function
cities <- list("Turin", "Barcelona", "London", "Paris", "Havanna",
               "Wien", "Mexiko City", "Hongkong", "Hamburg")
lapply(cities, nchar)
sapply(cities, nchar)
# another example
first_and_last <- function(name){
  name <- gsub(" ", "", name)
  letters <- strsplit(name, split = "")[[1]]
  c(first = min(letters), last = max(letters))
}
sapply(cities, first_and_last)
# the output now returns two values: the first and last character of the city
# name, in alphabetical order

# vapply
# vapply allows to specifically specify the output format
?vapply
lapply(cities, nchar)
sapply(cities, nchar)
vapply(cities, nchar, numeric(1))

sapply(cities, first_and_last)
vapply(cities, first_and_last, character(2))
vapply(cities, first_and_last, character(1))
vapply(cities, first_and_last, numeric(2))
# note the errors. they depend on the specification of the "fun.value"-argument
# in the vapply-function. Always think about what your function should return.

################################################################################

## time & date
# whats todays date?
today <- Sys.Date()
now <- Sys.time()
today
now
# what class are dates?
class(today)
class(now)
# the POSIXct and POSIXt classes make sure, that dates and times are comparable
# across different systems (as long as they know the POSIX standard)
my_date <- as.Date("1820-28-11")
# make sure to use the proper date structure
my_date <- as.Date("1820-11-28")
my_date
# or specifiy your date structure explicitely
my_date <- as.Date("1820-28-11", format = "%Y-%d-%m")
my_date
class(my_date)
# you can also create POSIXct objects
my_time <- as.POSIXct("1967-06-02 13:12:26")
my_time
class(my_time)
# Date arithmetic
# calculate dates
my_date+1
# calculate time differences
my_date2 <- as.Date("1818-05-05")
my_date-my_date2 # Karl Marx was born 938 days before Friedrich Engels
my_time2 <- as.POSIXct("1968-04-02 16:10:27")
my_time2+1
my_time-my_time2
my_time2-my_time
# how do dates work in R, whats under the hood?
unclass(my_date)
# the console returns a value of -54455. This is the difference in days between
# the 1st of January 1970, the reference value R uses and the birth of Engels
my_date3 <- as.Date("1970-01-01")
my_date3-my_date
# if you are calculating dates, you actually calculate single values that are 
# linked to 01.01.1970 as a reference value.






## Subsetting
# usually done with [ ]
# indexing in R starts with 1 
x <- 11:20
# select first three elements by position
x[c(1,2,3)]
x[c(3,1,2)]
# create vectors that are larger "subsets" of the original ones
x[c(1,1,2,3,1,1:10)]
# create new vectors based on subsets
y <- x[1:5]
# insert new values
x[c(7,5)] <- 1000
x
# we can also use functions to give positions:
x[length(x)] <- 999
x
# What does this do?
x[seq(1, length(x), by=2)] <- x[seq(1, length(x), by=2)] * 2
x
# you can also use the subset function to create subsets. However, the function
# might struggle with large data sets.
?subset


