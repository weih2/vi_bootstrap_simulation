source("gen_data.R")
source("init_update.R")
source("gibbs_sampler.R")

n.burnin.steps = 10000

# calculate the variance
n.inter = 150
n.sample = 200

test.seq = floor( exp( seq(5, 8, 0.2)))
res1 = numeric(0)
res2 = numeric(0)

for(n in test.seq){
  N <<- n
  var.mu.mean = numeric(K)
  var.max.abs.mean = numeric(0)
  
  for(fdjwo in 1:1000){
    gen.new.data()
    old.sample = init.update()
    old.sample = gibbs.sampler.cxx(x, old.sample, n.burnin.steps)
    mu.sample = matrix(nrow = 0, ncol = 3)
    for(i1 in 1:n.sample){
      old.sample = gibbs.sampler.cxx(x, old.sample, n.inter)
      mu.sample = rbind(mu.sample, old.sample$mu)
    }
    abs.error = abs(sweep(mu.sample, 2, mu0))
    max.abs.error = mean( apply(abs.error, 1, max) )
    var.max.abs.mean = c(var.max.abs.mean, max.abs.error)
    
    var.mu = var(mu.sample)
    var.mu = diag(solve(var.mu))
    var.mu = 1/var.mu
    
    var.mu.mean = var.mu.mean + var.mu
  }
  
  var.mu.mean = var.mu.mean/1000
  show(var.mu.mean)
  res1 = c(res1, mean(var.max.abs.mean))
  res2 = c(res2, sd(var.max.abs.mean))
}

show(res1)
show(res2)
