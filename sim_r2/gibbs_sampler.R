library(BoomSpikeSlab)

########### setup usually works for constructing credible set
n.samples = 1000
n.inter = 10

n.burnin = 10^4

n.iter = n.burnin + n.samples * n.inter

sample.index = n.burnin + (1:n.samples)*n.inter

###########

gibbs.sampler.wrapper <- function(o){
  gibbs.sampler = lm.spike(y~X - 1, niter = n.iter, data = original.data, ping = 0)
  betas.samples = gibbs.sampler$beta[sample.index, ]
  apply(betas.samples, 2, function(samples){
    return(c(quantile(samples, 0.025),
             quantile(samples, 0.975)))
  })
}

###########