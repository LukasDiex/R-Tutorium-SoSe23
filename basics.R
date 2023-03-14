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
# code. The script saves your code and automically appears if you start R the
# next time. Without explecitely forcing R to, no code will be run when using
# the script.
# The "Console" actually runs your code. If you want to run the code you wrote
# in the script, you copy it into the console, or push the "strg/cmd"+"enter"
# keys simultaneously. The console then gives you feedback as your code is 
# running. However, the console only saves your code during the current working
# session. If you close RStudio, your code will be gone. 
# If there are any errors in your code, the console will stop and "give you a
# hint" on where to look and how to fix the error.
# The "Environment" gives an overview of the datasets, variables, lists, or 
# whatever you are loading into R. You will get a clue in the following
# examples. Lastly, there is some kind of explorer. It shows you all the files
# that are currently in your project folder. Furthermore, you can switch to 
# the "Help" tab. Being able to read the help tab will make your life easier,
# when working with new packages. 

# let's start with some easy examples
## cheap calculator
1+1
# after running the code, the console shows you the result
# however, this result is not saved anywhere
a <- 1+1
# the arrow pointing to the a indicates that we defined "a" as the result of 
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
# if your environment is empty again, you have already succesfully used a 
# function. All functions follow the same pattern:
# name(argument1, argument2, ...)
# actually every operation is a function
'+'(2,4)
# functions can also be nested and combined: (for the moment when typing 
# functions on your own, don't mind the dropdown menu that appears)
exp(log(25))
3*exp(13^12+log(6))
# if you don't know what your function does, just ask R, it will automatically 
# redirect you to the respective help page in the help tab
?exp

## Vectors
# you can define "a" as vector of numbers
a <- c(1,2,3,4,5)
b <- c(1:5)
# you can also combine functions and vectors
c <- c(exp(1),exp(2),exp(3),exp(4),exp(5))





