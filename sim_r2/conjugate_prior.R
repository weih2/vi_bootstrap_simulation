##############

# conjugate prior sigma IG(0.001, 0.001)

a0 = 0.001
b0 = 0.001

# conjugate prior beta N(mu0, sigma^2 * inv.lambda0)
mu0 = numeric(n.pars)
Lambda.0 = diag(n.pars)

# analytic posterior form
weighted.data = list()
weighted.mu.n = NULL

posterior.cal <- function(weighted = FALSE, weights = NULL){
  if(! weighted){
    Lambda.n = t( original.data$X ) %*% original.data$X + Lambda.0
    inv.Lambda.n <<- solve(Lambda.n)
    
    beta.hat = lm(y ~ X - 1, original.data)$coefficients
    mu.n <<- inv.Lambda.n %*% ( t( original.data$X ) %*% 
                                original.data$X %*% beta.hat + Lambda.0%*% mu0)
    
    an <<- a0 + n.obs/2
    bn <<- b0 + (t(original.data$y) %*% original.data$y + t(mu0) %*% Lambda.0 %*% mu0 - 
                 t(mu.n) %*% Lambda.n %*% mu.n)/2
    
    lim.e.sigma.inv <<- as.numeric( (an - 1) / (bn + n.pars/2 - 1))
    
  }else{
    weighted.data$y <<- sqrt(weights) * original.data$y
    weighted.data$X <<- diag(sqrt(weights)) %*% original.data$X
    # change data, do a equivalent fit
    Lambda.n = t( weighted.data$X ) %*% weighted.data$X + Lambda.0
    inv.Lambda.n <<- solve(Lambda.n)
    
    beta.hat = lm(y ~ X - 1, weighted.data)$coefficients
    # MAP
    weighted.mu.n <<- inv.Lambda.n %*% ( t( weighted.data$X ) %*% 
                                  weighted.data$X %*% beta.hat + Lambda.0%*% mu0)
  }
  return(NULL)
}

# sample from exact posterior
sample.exact <- function(o){
  sigma2.sample = 1/rgamma(n = 1, shape = an, rate = bn)
  beta.sample = mvrnorm(n = 1, mu = mu.n, Sigma = sigma2.sample * inv.Lambda.n)
  return(beta.sample)
}

exact.credit.set.sample <- function(n.samples){
  beta.samples = sapply(1:n.samples, sample.exact)
  
  apply(beta.samples, 1, function(samp){
    c(quantile(samp, 0.025),
      quantile(samp, 0.975))
  })
}

# sample from variational posterior
# limit of CAVI can be directly derived by the following:

sample.limit <- function(o){
  beta.sample = mvrnorm(n = 1, mu = mu.n, Sigma = inv.Lambda.n / lim.e.sigma.inv)
  return(beta.sample)
}

var.credit.set.sample <- function(n.samples = 100){
  beta.var.samples = sapply(1:n.samples, sample.limit)
  
  apply(beta.var.samples, 1, function(samp){
    c(quantile(samp, 0.025),
      quantile(samp, 0.975))
  })
}

# sample from variational independent sampler
sample.independent <- function(o){
  weights = rexp(n = n.obs)
  posterior.cal(weighted = TRUE, weights = weights)
  return(weighted.mu.n)
}


var.credit.set.independence.sample <- function(n.samples){
  beta.independent.samples = sapply(1:n.samples, sample.independent)
  
  apply(beta.independent.samples, 1, function(samp){
    c(quantile(samp, 0.025),
      quantile(samp, 0.975))
  })
}

######### utility
check.covered <- function(credit.set){
  return(
    (beta >= credit.set[1,]) &
      (beta <= credit.set[2,])
  )
}
######### that should do it