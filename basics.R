
# Welcome to the R-Tutorial 
# this file will guide you around the basic settings of RStudio and will
# introduce you to some basic operations in R

# R shows you 4 quadrants, each representing a different screen
# you can adjust and reorder them freely; find out what suites you best
# 1. go to "Tools" -> "Global Options" -> Pane Layout
# you can also choose more screens but we won't need them here
# Furthermore, you can change the color-scheme by going to "Tools" ->
# "Global Options" -> "Appearance"

# Now, what do these quadrants do?
# The one you will use the most is the one showing your "script". Especially
# if you are not used to coding in R, you will use this one to write your
# code. The script saves your code and automatically appears if you start R the
# next time. Without explicitly forcing R to, no code will be run when using
# the script.
# The "Console" actually runs your code. If you want to run the code you wrote
# in the script, you copy it into the console, or push the "strg/cmd"+"enter"
# keys simultaneously. The console then gives you feedback as your code is 
# running. However, the console only saves your code during the current working
# session. If you close RStudio, your code will be gone. 
# If there are any errors in your code, the console will stop and "give you a
# hint" on where to look and how to fix the error.
# The "Environment" gives an overview of the data sets, variables, lists, or 
# whatever you are loading into R. You will get a clue in the following
# examples. Lastly, there is some kind of explorer. It shows you all the files
# that are currently in your project folder. Furthermore, you can switch to 
# the "Help" tab. Being able to read the help tab will make your life easier,
# when working with new packages. 

# One last thing before we start coding: always document your code. most of the 
# time you will work on your R-projects in groups. In order for your colleagues
# to understand what you did, it is crucial to leave some comments on what the
# code line is doing. Therefore, using "#" in front of your notes tells R that
# whatever is written after a # is not code to be run. 
# let's start with some easy examples
## cheap calculator
1+1
# after running the code, the console shows you the result
# however, this result is not saved anywhere
a <- 1+1
# the arrow pointing to the "a" indicates that we defined "a" as the result of 
# our 1+1 calculation. however, now the console doesn't show a result. Take 
# care when naming your values as R is sensitive to upper and lower case 
# letters. also, letters can be overwritten. WARNING: actually everything, 
# including functions can be overwritten.
a
# in order to see the result we can now simply run "a" 
# also, notice that your environment now shows you that you have defined "a"
# as having the value 2. 
# of course this works with every arithmetic type
b <- 1-1
c <- 2*2
d <- c/b
# now as dividing by zero is not possible arithmetically, the console, and also
# the environment show "Inf"
# also, space does not matter:
e <- 5*                     8
f <- 40 /
  5
# you can also chain different operations in on line
1+1; 2*2
a;b

# the modulo operator "%%": 
13%%6
# this operator returns the remainder of the division of 2 numbers
# powers:
g <- 5^7
# exponent:
h <- exp(25)
# natural log:
i <- log(25)
j <- log(exp(25))
k <- exp(log(25))

# we are done with the basic operations in R. as we do not need these values,
# we will get rid off them. 
# if you want to get rid off only one entry in your environment, use:
rm(a)
# if you want to get rid off all entries, use:
rm(list = ls())

## Functions
# if your environment is empty again, you have already successfully used a 
# function. All functions follow the same pattern:
# name(argument1, argument2, ...)
# sd() is a function returning you the standard deviation of whatever is inside
# the function, e.g. a vector of numbers.
sd(c(1,2,3,4))
# you can also assign a value to a variable and put it inside the function
numbers <- c(1,2,3,4)
sd(numbers)
# actually every operation is a function
'+'(2,4)
# functions can also be nested and combined: (for the moment when typing 
# functions on your own, don't mind the dropdown menu that appears)
exp(log(25))
3*exp(13^12+log(6))
# if you don't know what your function does, just ask R, it will automatically 
# redirect you to the respective help page in the help tab
?exp
# functions can also be used with "pipes". these are not of base R, but need 
# the dplyr package. we will look at the package later. 
5%>%exp
library(dplyr)
5%>%exp
# the %>%-operator is the pipe that basically passes the left hand side of the 
# operator to the first argument of the right hand side operator

## Vectors
# you can define "a" as vector of numbers
a <- c(1,2,3,4,5)
b <- c(1:5)
# you can also combine functions and vectors
c <- c(exp(1),exp(2),exp(3),exp(4),exp(5))

## TASK
# solve x^2 + 5*x + 6 = 0 
# Tip: you will need two lines (+/-)
# use pq-formula
# the function for the square root is called sqrt()
# solution starts at line 140
p <- 6 
q <- 5












# Solution
-p/2 + sqrt( (p/2)^2 - q ) 
-p/2 - ( (p/2)^2 - q ) ^ (1/2)

################################################################################

## Data types
# R has a wide variety of data types including scalars, vectors (numerical, 
# character, logical), matrices, data frames, and lists.

## Vectors
a <- c(1,2,5.3,6,-2,4) # numeric vector
b <- c("one","two","three") # character vector
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector
d <- c(1,2,7) #integer vector, same as d <- c(1L,2L,7L)

# Refer to elements of a vector using subscripts.
a[c(2,4)] # 2nd and 4th elements of vector
a[c(2:4)] # 2nd until the 4th elements of vector

## Matrices
# in R a matrix is a collection of elements of the same data type (numeric,
# character, etc.) and length, arranged into a fixed number of rows and columns. Therefore,
# it is called two-dimensional.
#The general format is:

# mymatrix <- matrix(vector, nrow=r, ncol=c, byrow=FALSE, 
#                    dimnames=list(char_vector_rownames, char_vector_colnames))

# byrow=TRUE indicates that the matrix should be filled by rows. byrow=FALSE 
# indicates that the matrix should be filled by columns (the default). dimnames
# provides optional labels for the  columns and rows.
# generates 5 x 4 numeric matrix 
y <- matrix(1:20, nrow=5, ncol=4)
# another example
cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2") 
mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE, dimnames=list(rnames, 
                                                                    cnames))
mymatrix
# Identify rows, columns or elements using subscripts.
y[,4] # 4th column of matrix
y[3,] # 3rd row of matrix 
y[2:4,1:3] # rows 2,3,4 of columns 1,2,3

## Arrays
# Arrays are similar to matrices but can have more than two dimensions. 
?array

## Data Frames
# A data frame is more general than a matrix in that different columns can 
# have different modes (numeric, character, factor, etc.).
d <- c(1,2,3,4)
e <- c("red", "white", "red", NA)
f <- c(TRUE,TRUE,TRUE,FALSE)
# build data frame (coerce to data frame by as.data.frame)
myframe <- data.frame(d,e,f)                
myframe
names(myframe) <- c("ID","Color","Passed")  # variable names
myframe
#There are a variety of ways to identify the elements of a data frame 
# columns 1 to 2 of the data frame
myframe[,1:2]                
# columns ID and Age from data frame
myframe[,c("ID","Color")]  
# variable x1 in the data frame
myframe$ID    
# 3rd element of variable x1 in the data frame
myframe$ID[3]              

## Lists
# An ordered collection of objects (components). A list allows you to gather a 
# variety of (possibly unrelated) objects under one name.
# objects in a list can be of different length (e.g. a list of data frames with
# varying dimensions)
# example of a list with 4 components - a string, a numeric vector, a matrix, 
# and a scaler 
mylist <- list(name="bestlist", numbers=a, matrix=y, age=5)
mylist
# example of a list containing two lists:
# v <- c(list1,list2)
# Identify elements of a list using the [[]] convention.
mylist[[2]] # 2nd component of the list
mylist[["numbers"]] # component named mynumbers in list
# lists names of all elements in a list
names(mylist)
# we can also access multiple items of a list using single brackets 
mylist[c(1:2)]

## Factors
# Tell R that a variable is nominal by making it a factor. The factor stores 
# the nominal values as a vector of integers in the range [ 1... k ] (where k 
# is the number of unique values in the nominal variable), and an internal 
# vector of character strings (the original values) mapped to these integers.

# example
# variable gender with 20 "male" entries and 30 "female" entries 
# (the rep command replicates a given argument a given number of times)
# entries are saved as characters
gender <- c(rep("male",20), rep("female", 30), rep("other", 10)) 
gender
class(gender)
summary(gender)
# transform characters into factors
gender <- factor(gender) 
gender
class(gender)
# stores gender as 30 1s and 20 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal variable 
summary(gender)
# R will treat factors as nominal variables in statistical procedures and 
# graphical analyses. 






























