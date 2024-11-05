### Load packages
library(MASS)
library(tidyverse)
library(foreach)
library(doParallel)
library(doRNG)

### First read in the arguments listed at the command line
args <- (commandArgs(TRUE))
print(args)

### args is now a list of character vectors
### First check to see if arguments are passed.
### Then cycle through each element of the list and evaluate the expressions.

if(length(args) == 0){
  print("No arguments supplied.")
  
  ## supply default values
  N <- 100         # sample size 
  B <- 1000        # number of bootstrap replications
  S <- 1000   # number of simulation iterations
}else{
  for (i in (1:length(args))) eval(parse(text=args[[i]]))
}

#ncores = Sys.getenv("SLURM_CPUS_PER_TASK")
ncores <- detectCores(all.tests = TRUE, logical = TRUE)
ncores

registerDoParallel(cores=ncores)# Shows the number of Parallel Workers to be used

### Code to run simulation (see doParallel_example.R)
rng <- RNGseq(B * S, 2024)
out <- foreach(i=1:S, .combine=rbind) %:%
  foreach(j=1:B, r=rng[(i-1)*S+1:S], .combine=c) %dopar% {
    # set RNG seed
    rngtools::setRNG(r)
    
    # simulate data from log normal distribution
    dat <- rlnorm(N)
    ind <- sample(N, N, replace = TRUE)
    samp.median <- median(dat[ind])
  }
f <- function(x)quantile(x, c(0.025, 0.975))
simout <- apply(out, 1, f)


### Output simulation results
outfile <- paste0("simout_N", N,
                  "_B", B,
                  ".txt")

write.table(simout, outfile, col.names = T, row.names = F)