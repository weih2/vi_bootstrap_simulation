N <<- 500
n.burnin.steps = 5000

# calculate the variance
n.inter = 20
n.sample = 1000

mcmc.credit.set.wrapper <- function(o){
  old.sample = init.update()
  # burn in
  old.sample = gibbs.sampler.cxx(x, old.sample, 1, n.burnin.steps)
  mu.sample = matrix(nrow = 0, ncol = 3)
  # real sample
  old.sample = gibbs.sampler.cxx(x, old.sample, n.sample, n.inter)
  mu.sample = old.sample$mu
  
  apply(mu.sample, 2, function(samples){
    return(c(
      quantile(samples, 0.025),
      quantile(samples, 0.975)
    ))
  })
}

test.seq = exp(seq(-3, 2, by = 0.1))
n.test.seq = 0

for(delta in test.seq){
  n.test.seq = n.test.seq + 1
  mu0 <<- c(-delta, 0, delta)
  mcmc.covered = numeric(3)
  mcmc.credit.set.lens = matrix(nrow = 1000, ncol = 3)
  
  for(n.exp in 1:1000){
    gen.new.data()
    mcmc.credible.set = mcmc.credit.set.wrapper()
    mcmc.covered = mcmc.covered + check.covered(mcmc.credible.set)
    mcmc.credit.set.lens[n.exp, ] = mcmc.credible.set[2,] - mcmc.credible.set[1,]
  }
  
  show(mcmc.covered)
  if(n.test.seq %% 10 == 0){
    show(apply(mcmc.credit.set.lens, 2, mean))
    show(apply(mcmc.credit.set.lens, 2, sd))
  }
}
          

