# Description  ------------------------------------------------------------
##########################################################################################
# Initialize the project
# Created by Marc-Olivier Beausoleil
# McGill University 
# Created 2022-09-07
# Why: 
# Requires 
# NOTES: 
##########################################################################################
cat("Initializing project and preparing R.\n")

# Load libraries ----------------------------------------------------------
# if (!"librarian" %in% installed.packages()) {
#   install.packages("librarian") 
# } else {
#   cat("librarian package already installed. Loading package librarian.\n")
#   library(librarian)
# }
# librarian::shelf(tidyverse, cran_repo = 'https://cran.r-project.org')
if (!"groundhog" %in% installed.packages()) {
  install.packages("groundhog") 
} else {
  cat("groundhog package already installed. Loading package groundhog\n")
  library(groundhog)
}
pkgs = c("tidyverse")
# Should be at least 2 days in the past Sys.Date()-2
groundhog.library(pkgs, "2022-09-05")

# Folder structure --------------------------------------------------------
cat("Creating folders if needed\n")
if (basename(getwd()) != "report") {
  folders = c("output/session_info",
              "data/WF_model",
              "data/HW_principle",
              # "data/raw",      # not needed 
              # "data/cleaned",  # not needed 
              "report/references",
              "report/styles"
              )
  junk <- mapply(FUN = dir.create, 
                 path = folders, 
                 showWarnings = FALSE); rm(list = "junk")
}

cat("Done!\n")

