library(MASS)

### universal for each update
alpha1 = 0.001
alpha2 = 0.001
a = alpha1 + n.obs/2 + n.pars/2 

### initialize quantities unchanged per
### data sample
init.tau <- function(){
  sigma2.est = sigma(lm(y~X-1, data = original.data))^2
  tau <<- sqrt( c(1/n.obs, log(n.obs)) * sigma2.est)
  tau.i2 <<- tau ^ (-2)
}

init.sample <- function(){
  list(
    beta.sample = rep(0, n.pars),
    sigma2.sample = sigma(lm(y~X-1, data = original.data))^2,
    Z.sample = sample.int(2, replace = T,
                          size = n.pars, prob = c(1/n.pars, 1 - 1/n.pars)) - 1
  )
}

### Gibbs sampling one iteration
gibbs.update = function(old.sample){
  # a = alpha1 + n.obs/2 + n.par/2
  # D.k : sequence of tau^{-2}
  D.k = tau.i2[old.sample$Z.sample + 1]
  
  V = solve( XTX + diag(D.k) )
  beta.var = V * old.sample$sigma2.sample
  beta.mean = V %*% XTy
  
  #   sample beta
  beta.sample = mvrnorm(n = 1, beta.mean, beta.var)
  # ---

  Z.pip.p = dnorm(beta.sample, mean = 0, sd = sqrt(old.sample$sigma2.sample) * tau[1])
  Z.npip.p = dnorm(beta.sample, mean = 0, sd = sqrt(old.sample$sigma2.sample) * tau[2])
  
  # update inclusion of beta
  # i.e. which gaussian component beta belongs to
  
  # sample poterior inclusion prob
  Z.pip = ( runif(n.pars) > Z.pip.p /(Z.pip.p + Z.npip.p) )
  # ---
  
  D.k = tau.i2[Z.pip + 1]
  
  b = alpha2 + sum( beta.sample^2 * D.k)/2 + 
    sum( (original.data$y - original.data$X %*% beta.sample)^2)/2
    
  # sample sigma2
  sigma2.sample = 1/rgamma(1, shape = a, rate = b)
  # ---
  
  return(list(
    beta.sample = beta.sample,
    sigma2.sample = sigma2.sample,
    Z.sample = Z.pip
  ))
}

### main sampler
gibbs.sampler <- function(n.burnin, n.samples, n.inter){
  sample0 = init.sample()
  
  beta.samples = matrix(nrow = 0, ncol = n.pars)
  
  for(i in 1:n.burnin) sample0 = gibbs.update(sample0)
  
  for(i in 1:n.samples){
    for(j in 1:n.inter){
      sample0 = gibbs.update(sample0)
    }
    beta.samples = rbind(beta.samples, sample0$beta.sample)
  }
  return(beta.samples)
}

###### credible set construction
########### setup usually works for constructing credible set
n.samples = 1000
n.inter = 10

n.burnin = 10^4
###########
ci.naveen <- function(){
  beta.samples = gibbs.sampler(n.burnin, n.samples, n.inter)
  
  return(apply(beta.samples, 2, function(samps){
    c(quantile(samps, 0.025), quantile(samps, 0.975))
  }))
}


