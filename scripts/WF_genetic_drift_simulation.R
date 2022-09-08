# Description  ------------------------------------------------------------
##########################################################################################
# Wright-Fisher genetic drift model 

# Created by Marc-Olivier Beausoleil
# McGill University 

# Created 2022-09-07

# Why: 
  # This file contains R functions to generate genetic drift from Wright-Fisher model and Hardy-Weinberg principle genotype frequencies
# Requires 
  # No external requirements. Everything in base R (much faster this way). 
# NOTES: 
  # modified from http://statisticalrecipes.blogspot.com/2012/02/simulating-genetic-drift.html
  # See also chapter 2 in  Gillespie, J. H. 2004. Population genetics: a concise guide. Second edition. The Johns Hopkins University Press, Baltimore, Maryland. 
  # Prints plots much faster and makes it easier to modify the parameters needed to gain insights 
##########################################################################################

# Simulate Genetic Drift (using Wright-Fisher model) ----------------------
wf.drift <- function(N = 20, # Nb of diploid individuals
                     p = .5, # Frequency of starting allele for p (or A1, q is A2)
                     N.gen = 100, # Nb of generations
                     N.sim = 500, # Nb of simulations
                     plot = TRUE, # Do you want to plot the results 
                     seed = NULL) { # For reproducibility, you can add a seed 
  N.chrom = 2*N # number of chromosomes
  q = 1-p # find the alternative allele (A2)
  
  # Simulation --------------------- 
  
  # Define objects that will be filled when performing the simulation 
  # Initialize array.
  X = array(0, dim = c(N.gen, N.sim)) # This array contains N.gen rows (number of generations) and N.sim columns (number of replicate populations)
  X[1,] = rep(N.chrom*p, N.sim) # initialize number of A1 alleles in first generation (first row)
  
  # For reproducibility, adding a seed number to replicate the simulation 
  if (!is.null(seed)) {
    set.seed(seed = seed)
  }
  
  # Populate the X array for all generations
  for(i in 2:N.gen){ # Starting from the second row until the last generation
    X[i,] <- mapply(function(x) rbinom(n = 1, # Use a pseudo-random binomial generator to get the 'success' 
                                       size = N.chrom, # From N.chrom values 
                                       prob = x), # With a probability dependent on the previous generation (see next line)
                    x = X[i-1,]/N.chrom) # Calculate the proportion of p allele in each population in the *previous* generation
  }  
  
  # Calculate the proportion of p allele 
  X = data.frame(X/N.chrom)
  
  # Plot the results 
  if (plot) {
    matplot(X, 
            type = "l", # lines 
            main = paste0("W-F Genetic Drift; N=", N, "; p=", p), # Title 
            xlab = paste0("Generation Total=", N.gen),            # x-axis lab title
            ylab = "Allele Frequency",                            # y-axis lab title
            ylim = c(0,1))                                        # limit of y-axis
  }
  
  # Print the data 
  return(X)
}

# Usage
# wf.drift()


# Fixation rate for WF model ----------------------------------------------
fixation <- function(wf.sim) {
  # Find the alleles that are fixated (1 or 0)
  fixated = apply(wf.sim, 2, function(x) which(x==1 | x == 0)[1])
  
  # Percentage of fixation rate (100% means that the allele was fixated in all replicate population)
  fixation.rate = length(which(!is.na(fixated)))/ncol(wf.sim)*100
  
  # Mean number of generations to fixation (is no fixation, will return NA)
  mean.fix = mean(fixated, na.rm = TRUE)
  # if(is.na(mean.fix)) {mean.fix = "> max number of generations"}
  
  # Return each value in a list 
  return(list(fixated = fixated, 
              fixation.rate = fixation.rate, 
              mean.fix = mean.fix ))
}

# Usage 
# fixation(wf.drift())


# Calculate expected genotype frequencies ---------------------------------
h.p.2pq.q = function(p) { # p is a frequency from 0 to 1 
  q = 1- p 
    # Recall that 
    # 1 = p + q => 
    # 1^2 = (p + q)^2 => 
    # 1 = p^2 + 2*p*q + q^2 =>  
    # 1 - (p^2 + q^2) = 2*p*q 
    heterozygosity = 2*(p*q) 
    homozygosity.p = p^2
    homozygosity.q = q^2
    # Return homo and heterozygosity 
    return(list(h.p = as.vector(homozygosity.p), 
                h2pq = as.vector(heterozygosity),
                h.q = as.vector(homozygosity.q)))  
}

# Usage
# h.p.2pq.q(.5)


