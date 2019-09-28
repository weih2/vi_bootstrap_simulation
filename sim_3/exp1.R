library(inline)
library(RcppArmadillo)

source("gen_data.R")
source("init_update.R")
source("gibbs_sampler.R")

n.burnin.steps = 5000

# calculate the variance
n.inter = 20
n.sample = 1000

test.seq = floor( exp( seq(5, 8, 0.2)))
res1 = numeric(0)
res2 = numeric(0)

res3 = numeric(K)
res4 = numeric(K)

for(n in test.seq){
  N <<- n
  var.mu.sample = numeric(K)
  var.max.abs.mean = numeric(0)
  
  for(fdjwo in 1:500){
    if(fdjwo %% 10 == 0) show(fdjwo)
    gen.new.data()
    old.sample = init.update()
    # burn in
    old.sample = gibbs.sampler.cxx(x, old.sample, 1, n.burnin.steps)
    mu.sample = matrix(nrow = 0, ncol = 3)
    # real sample
    old.sample = gibbs.sampler.cxx(x, old.sample, n.sample, n.inter)
    mu.sample = old.sample$mu
    
    abs.error = abs(sweep(mu.sample, 2, mu0))
    max.abs.error = mean( apply(abs.error, 1, max) )
    var.max.abs.mean = c(var.max.abs.mean, max.abs.error)
    
    var.mu = var(mu.sample)
    var.mu = diag(solve(var.mu))
    var.mu = 1/var.mu
    
    var.mu.sample = rbind(var.mu.sample, var.mu)
  }
  
    var.mu.sample = var.mu.sample[-1, ]
  res3 = rbind(res3, apply(var.mu.sample, 2, mean))
  res4 = rbind(res4, apply(var.mu.sample, 2, sd))
  res1 = c(res1, mean(var.max.abs.mean))
  res2 = c(res2, sd(var.max.abs.mean))
}

show(res1)
show(res2)
res3 = res3[-1,]
res4 = res4[-1,]
show(res3)
show(res4)
