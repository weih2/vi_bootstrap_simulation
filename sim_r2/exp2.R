# source("conjugate_prior.R")

# n.experiments = 1000
# set on configuration files

for(i in 0:19){
  auto.cor <<- 0.05 * i
  # 4 types of convergence
  
  res = matrix(0, nrow = 4, ncol = n.pars)
  for(n in 1:n.experiments){
    original.data <<- gen.everything()
    
    posterior.cal()
    # sample from exact posterior
    res[1,] = res[1,] + check.covered(exact.credit.set.sample(n.samples))
    
    # sample from variational posterior
    res[2,] = res[2,] + check.covered(var.credit.set.sample(n.samples))
    
    # sample from independence sampler
    credible.set.independent = var.credit.set.independence.sample(n.samples)
    res[3,] = res[3,] + check.covered(credible.set.independent)
    
    # sample from independence sampler v2
    credible.set.independent2 = - sweep ( exact.credit.set.sample(n.samples),2, 2 * mu.n)
    credible.set.independent2 = credible.set.independent2[2:1, ]
    res[4,] = res[4,] + check.covered(credible.set.independent2)
  }
}
