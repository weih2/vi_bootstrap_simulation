library(MASS)

### universal for each update
a = alpha1 + n.obs/2 + n.par/2 

### initialize quantities unchanged per
### data sample
init.tau <- function(){
  sigma2.est = sigma(lm(y~X-1, data = original.data))^2
  tau = c(1/n.obs, log(n.obs)) * sigma2.est
  tau.i2 <<- tau ^ (-2)
}

init.sample <- function(){
  list(
    beta.sample = rep(0, n.pars),
    sigma2.sample = sigma(lm(y~X-1, data = original.data))^2,
    Z.sample = rep(1/n.pars, n.pars)
  )
}

### Gibbs sampling one iteration
gibbs.update = function(old.sample){
  # a = alpha1 + n.obs/2 + n.par/2
  # D.k : sequence of tau^{-2}
  D.k = tau.i2[old.sample$Z.sample + 1]
  
  V = solve( XTX + diag(D.k) )
  beta.var = V * old.sample$sigma2.sample
  beta.mean = V %*% XTY
  
  #   sample beta
  beta.sample = mvrnorm(n = 1, beta.mean, beta.var)
  # ---

  Z.pip.p = dnorm(beta.sample, mean = 0, sd = sqrt(sigma2) * tau1.2)
  Z.npip.p = dnorm(beta.sample, mean = 0, sd = sqrt(sigma2) * tau2.2)
  
  # update inclusion of beta
  # i.e. which gaussian component beta belongs to
  
  # sample poterior inclusion prob
  Z.pip = ( runif(n.pars) < Z.pip.p /(Z.pip.p + Z.npip.p) )
  # ---
  
  D.k = tau.i2[Z.pip + 1]
  
  b = alpha2 + sum( beta.sample^2 * D.k)/2 + 
    sum( (original.data$y - original.data$X %*% beta.sample)^2)/2
    
  # sample sigma2
  sigma2.sample = 1/rgamma(1, shape = a, rate = 1/b)
  # ---
  
  return(list(
    beta.sample = beta.sample,
    sigma2.sample = sigma2.sample,
    Z.sample = Z.pip
  ))
}

