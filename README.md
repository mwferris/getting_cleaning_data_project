# getting_cleaning_data_project
## run_analysis.R
This script downloads the zip file, unzips it, and consolodates all 
of the data into one R data frame, merged_data. 

The script also creates a second data frame containing the averages
of all the variables of merged_data, grouped by subject and activity.

## Dependencies
run_analysis.R depends on the dplyr package, which should be installed
automatically if it is not on the computer.

## Versions
dplyr - 0.7.0
R - 3.4.0      
