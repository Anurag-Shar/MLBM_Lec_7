# List of required packages
packages <- c("shiny", "quantmod", "ggplot2", "dplyr", "tidyr")

# Function to check and install missing packages
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Apply function to all required packages
sapply(packages, install_if_missing)
