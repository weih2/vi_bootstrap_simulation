source("point_estimate.R")

get.beta1.vwlb.cs = function(original.data, confidence){
  XTX <<- t(original.data$X) %*% (original.data$X)
  diagXTX <<- diag(XTX)
  XTy <<- t(original.data$X) %*% (original.data$y)
  
  beta1.point.estimate = main.loop()$beta.posterior$mu[1]
  
  beta1.bootstrap.map = numeric(0)
  
  for(i in 1:n.b.samples){
    weights = gen.weights()
    
    data.X <<- diag(sqrt(weights)) %*% original.data$X
    data.y <<- diag(sqrt(weights)) %*% original.data$y
    
    XTX <<- t(original.data$X) %*% diag(weights) %*% original.data$X
    diagXTX <<- diag(XTX)
    XTy <<- t(original.data$X) %*% diag(weights) %*% original.data$y
    
    beta1.bootstrap.map = c(beta1.bootstrap.map, 
                            main.loop()$beta.posterior$mu[1])
  }
  
  vwlb.ci1 = c(
    quantile(beta1.bootstrap.map, (1 + confidence)/2),
    quantile(beta1.bootstrap.map, (1 - confidence)/2)
  )
  
  vwlb.ci1 = 2 * beta1.point.estimate - vwlb.ci1
  
  vwlb.ci2 = c(
    mean(beta1.bootstrap.map) - sd(beta1.bootstrap.map) * qnorm(0.975),
    mean(beta1.bootstrap.map) + sd(beta1.bootstrap.map) * qnorm(0.975)
  )
  
  return(
    list(
      vwlb.ci1 = vwlb.ci1,
      vwlb.ci2 = vwlb.ci2
    )
  )
  # return(beta1.bootstrap.map)
}


