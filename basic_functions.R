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
# frequency table of vector
table(x) 
# simple plot with index on x-axis and values on y-axis
plot(x) 
# summarise info on object, output depends on object!
summary(x) 
# print object to console
print('Hello world') 
# round value, second argument gives decimal place
round(3.5467, digits = 3) 
# create sequence of numbers
seq(from=1, to=10, by=3) 
# get information on functions
?seq 
# You do not need to type in the arguments' names if you know their
# position
seq(1,10,2) 
# sqaure root of something
sqrt(16)
#sine
sin(pi/2)
#cosine
cos(0)  
#tangent
tan(0)  
#natural logarithm
log(1)
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
# WARNING do not use "T <- 'something else' as this is the abbreviation of TRUE

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
rnorm(1,0,1)       
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
#distributen Other distributions may vary in their parametrization.

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
# we can also use functions to give positions:
x[length(x)] <- 999
# What does this do?
x[seq(1, length(x), by=2)] <- x[seq(1, length(x), by=2)] * 2
# you can also use the subset function to create subsets
?subset
