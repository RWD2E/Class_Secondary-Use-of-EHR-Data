#######################################################################################
#R Packages                               
#What makes R a very useful tool for analysis is that there is an active community of      
#people who develop and share analytic-ready packages everyday.                          
#The Comprehensive R Archive Network, or CRAN is a network of repositories where all      
#validated packages are maintained
#=====================================================================================
#R Functions
#What's contained in R packages are "functions". The "Functions" just do something
#with given set of instructions, or "arguments", and return results for you.
#There are a lot of powerful functions in R packages that can help you with 
#most of the analysis needs. We will discover them along the way
#######################################################################################

#=============================================================================
# Install and Load R packages
#=============================================================================
# To install distributed packages in R using base packages, it usually takes two steps:
# Step 1: install packages using install.package() function
install.packages("pacman")

# Step 2: load packages - can use either of the followings:
require(pacman)  # Gives a confirmation message.
library(pacman)  # No message.

# For multiple packages, you need to repeat step 1 and step 2 for each package.

# Alternatively, by using the p_load function from "pacman" package, 
# you can install and load multiple packages in 1 step, such as:
p_load(pacman, dplyr, tidyr, stringr, ggplot2, rmarkdown, RJDBC, DBI, sqldf)

# or
pacman::p_load(pacman, dplyr, tidyr, stringr, ggplot2, rmarkdown, RJDBC, DBI, sqldf) 

#============================================================================
# Get Help to understand new "Functions"
#============================================================================

?p_load
??p_load
example("p_load")

#============================================================================
# Clear Package
#============================================================================
# Similarly, you can clear packages using base function (one at a time):
detach("package:pacman", unload = TRUE)

# Or use the p_unload function in "pacman" package to clear multiple packages at once
p_unload(dplyr, tidyr, stringr) # Clear specific packages
p_unload(all)  # Easier: clears all add-ons


