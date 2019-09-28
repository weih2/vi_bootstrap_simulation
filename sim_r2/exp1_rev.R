## revised experiment 1

source("simulation_setup.R")
source("vwlb_estimate.R")
source("vb_cs.R")

n.experiments = 1000
n.b.samples = 500

data = gen.everything() # only a place holder
original.data = data

### prepare ingredients for the vb.credible.set.wrapper
cal.posterior <- function(o){
  XTX <<- t(original.data$X) %*% (original.data$X)
  diagXTX <<- diag(XTX)
  XTy <<- t(original.data$X) %*% (original.data$y)
  
  vb.posterior <<- main.loop()$beta.posterior
}

vb.credible.set.wrapper <- function(beta.posterior = vb.posterior, confidence = 0.95){
  sapply(1:n.pars, function(i) 
    vb.credible.set(beta.posterior = beta.posterior, confidence = confidence, i))
}

### prepare for weighted case

cal.weighted.posterior <- function(weights){
  data.X <<- diag(sqrt(weights)) %*% original.data$X
  data.y <<- diag(sqrt(weights)) %*% original.data$y
  
  XTX <<- t(original.data$X) %*% diag(weights) %*% original.data$X
  diagXTX <<- diag(XTX)
  XTy <<- t(original.data$X) %*% diag(weights) %*% original.data$y
  
  weighted.vb.posterior <<- main.loop()$beta.posterior
}

vb.indenpendent.sampler <- function(n.samples){
  beta.samples = matrix(nrow = 0, ncol = n.pars)
  for(n in 1:n.samples){
    weights = gen.weights()
    cal.weighted.posterior(weights)
    beta.samples = rbind(beta.samples, sapply(1:n.pars, function(i){
      if(weighted.vb.posterior$phi[i] < 0.5) return(0)
      else return(weighted.vb.posterior$mu[i])
    }))
  }
  return(beta.samples)
}

vb.indenpendent.credible.set <- function(n.samples){
  ## will generate two sets
  
}
