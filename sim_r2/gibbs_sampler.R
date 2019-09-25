library(BoomSpikeSlab)

###########
n.experiments = 1000

n.samples = 1000
n.inter = 100

n.burnin = 10^4

n.iter = n.burnin + n.samples * n.inter

sample.index = n.burnin + (1:n.samples)*n.inter
inclusion.total = numeric(length(beta))

for(n in 1:n.experiments){
  original.data <<- gen.everything()
  gibbs.sampler = lm.spike(y~X - 1, niter = n.iter, data = original.data)
  betas.samples = gibbs.sampler$beta[sample.index, ]
  credible.set = apply(betas.samples, 2, function(samples){
    return(c(quantile(samples, 0.025),
             quantile(samples, 0.975)))
  })
  
  inclusion = (beta < credible.set[2,]) & (beta > credible.set[1,])
  inclusion.total = inclusion.total + inclusion
}

inclusion.total / n.experiments

