# Description  ------------------------------------------------------------
##########################################################################################
# writting session info
# Created by Marc-Olivier Beausoleil
# McGill University 
# Created 2022-09-07
# Why: 
# Requires 
# NOTES: 
##########################################################################################

source("scripts/0.initialize.R")
# Session info ------------------------------------------------------------
# if (basename(getwd()) != "report") {

cat("Generate session information\n")

dir.create("output/session_info",showWarnings = FALSE)
sink("output/session_info/session_information.txt", append = FALSE)
# sink("~/Desktop/session_information.txt",append = FALSE)
cat("##### R Version Information ############################################################\n")
version

cat("\n\n##### Collect Information About the Current R Session ############################################################\n\n")
sessionInfo() 
# loadedNamespaces()
sink()
# }
