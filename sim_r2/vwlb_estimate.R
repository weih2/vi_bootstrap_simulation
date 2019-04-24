source("point_estimate.R")

n.experiments = 100
n.b.samples = 500
original.data = data

get.beta1.vwlb.cs = function(confidence){
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
  
  return( c(
    quantile(beta1.bootstrap.map, (1 - confidence)/2),
    quantile(beta1.bootstrap.map, (1 + confidence)/2)
  ))
  # return(beta1.bootstrap.map)
}

covered = 0
for(i in 1:n.experiments){
  original.data <<- gen.new.y(original.data)
  if(i %% 10 == 0) print(i)
  vwlb.cs = get.beta1.vwlb.cs(0.95)
  # print(vwlb.cs[1]); print(vwlb.cs[2])
  
  if(
    (vwlb.cs[1] < beta[1])&
    (vwlb.cs[2] > beta[1])
  ) covered = covered + 1
}

