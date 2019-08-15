source("gen_data.R")
source("init_update.R")
source("gibbs_sampler.R")

n.burnin.steps = 10000

# calculate the variance
n.inter = 100
n.sample = 1000

for(n in c(100, 200, 500, 1000, 2000)){
  N <<- n
  for(fdjwo in 1:10){
    gen.new.data()
    old.sample = init.update()
    for(i in 1:n.burnin.steps){
      old.sample = gibbs.sample(old.sample)
    }
    mu.sample = matrix(nrow = 0, ncol = 3)
    for(i1 in 1:n.sample){
      for(i2 in 1:n.inter){
        old.sample = gibbs.sample(old.sample)
      }
      # if(i1 %% 10 == 0) show(i1)
      mu.sample = rbind(mu.sample, old.sample$mu)
    }
    
    var.mu = var(mu.sample)
    var.mu = diag(solve(var.mu))
    var.mu = 1/var.mu
    show(var.mu)
  }
}
