source("point_estimate.R")

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

get.beta1.vwlb.cs = function(original.data, confidence){
  beta1.bootstrap.map = numeric(0)
  beta2.bootstrap.map = numeric(0)
  
  beta1.point.estimate = main.loop()$beta.posterior$mu[1]
  beta2.point.estimate = main.loop()$beta.posterior$mu[2]
  
  for(i in 1:n.b.samples){
    weights = gen.weights()
    
    data.X <<- diag(sqrt(weights)) %*% original.data$X
    data.y <<- diag(sqrt(weights)) %*% original.data$y
    
    XTX <<- t(original.data$X) %*% diag(weights) %*% original.data$X
    diagXTX <<- diag(XTX)
    XTy <<- t(original.data$X) %*% diag(weights) %*% original.data$y
    
    beta1.bootstrap.map = c(beta1.bootstrap.map, 
                            main.loop()$beta.posterior$mu[1])
    
    beta2.bootstrap.map = c(beta2.bootstrap.map, 
                            main.loop()$beta.posterior$mu[2])
  }
  
  vwlb.ci1 = c(
    quantile(beta1.bootstrap.map, (1 + confidence)/2),
    quantile(beta1.bootstrap.map, (1 - confidence)/2)
  )
  
  vwlb.ci1 = 2 * beta1.point.estimate - vwlb.ci1
  
  vwlb.ci1.2 = c(
    quantile(beta2.bootstrap.map, (1 + confidence)/2),
    quantile(beta2.bootstrap.map, (1 - confidence)/2)
  )
  
  vwlb.ci1.2 = 2 * beta2.point.estimate - vwlb.ci1.2
  
  vwlb.ci2 = c(
    mean(beta1.bootstrap.map) - sd(beta1.bootstrap.map) * qnorm(0.975),
    mean(beta1.bootstrap.map) + sd(beta1.bootstrap.map) * qnorm(0.975)
  )
  
  vwlb.ci2.2 = c(
    mean(beta2.bootstrap.map) - sd(beta2.bootstrap.map) * qnorm(0.975),
    mean(beta2.bootstrap.map) + sd(beta2.bootstrap.map) * qnorm(0.975)
  )
  
  return(
    list(
      vwlb.ci1 = vwlb.ci1,
      vwlb.ci2 = vwlb.ci2,
      # for beta_2
      vwlb.ci1.2 = vwlb.ci1.2,
      vwlb.ci2.2 = vwlb.ci2.2
    )
  )
  # return(beta1.bootstrap.map)
}


