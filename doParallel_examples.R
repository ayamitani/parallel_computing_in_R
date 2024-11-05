library(foreach)
library(doParallel)
library(doRNG)

# Use the environment variable SLURM_CPUS_PER_TASK to set the number of cores.
# This is for SLURM. Replace SLURM_CPUS_PER_TASK by the proper variable for your system.
# Avoid manually setting a number of cores.
#ncores = Sys.getenv("SLURM_CPUS_PER_TASK")
ncores <- detectCores(all.tests = TRUE, logical = TRUE)
ncores

registerDoParallel(cores=ncores)# Shows the number of Parallel Workers to be used
print(ncores) # this how many cores are available, and how many you have requested.
getDoParWorkers()# you can compare with the number of actual workers


# Bootstrap example
B <- 100000 # number of bootstrap iterations
out <- foreach(icount(B), .combine=c) %dopar% {
  # simulate data from log normal distribution
  dat <- rlnorm(N)
  ind <- sample(N, N, replace = TRUE)
  samp.median <- median(dat[ind])
}

# Bootstrap simulation example
B <- 1000 # number of bootstrap iterations
S <- 10   # total number of simulations
out <- foreach(icount(S), .combine=rbind) %:%
  foreach(icount(B), .combine=c) %dopar% {
    # simulate data from log normal distribution
    dat <- rlnorm(N)
    ind <- sample(N, N, replace = TRUE)
    samp.median <- median(dat[ind])
  }
f <- function(x)quantile(x, c(0.025, 0.975))
simout <- apply(out, 1, f)


# Make it reproducible by setting seed with doRNG package (chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://dorng.r-forge.r-project.org/vignettes/doRNG.pdf)
B <- 1000 # number of bootstrap iterations
S <- 10   # total number of simulations
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
