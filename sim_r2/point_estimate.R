data = gen.everything() 

# cavi settings
n.max.iter = 20
epsilon = 1e-3
prob.threshold = 1e-6

# prior parameters
# prior parameters for theta, will be uniform(0, 1)
a0 = 1
b0 = 1
# prior parameters for sigma2, will be IG(0.001, 0.001)
nu = 0.002
lambda = 1
# hyper parameter set fixed
nu1 = 1

XTX = t(data$X) %*% (data$X)
XTy = t(data$X) %*% (data$y)

cavi.estimate = function(beta.posterior, global.posterior, active.set){
  beta.posterior$
}

em.estimate = function(beta.posterior, global.posterior){
  global.posterior$theta.hat = 
    (sum(beta.posterior$phi) + a0 - 1)/
    (n.pars + a0 + b0 - 2)
  global.posterior$sigma2.hat = 
    sum((y - X %*% (beta.posterior$phi * beta.posterior$mu))^2)
  global.posterior$sigma2.hat = 
  return(global.posterior)
}

# main loop
main.loop = function(o){
  beta.posterior = init.beta.posterior()
  global.posterior = init.global.posterior()
  
  new_entropy = rep(0, n.pars)
  active.set = rep(TRUE, n.pars)
  
  repeat{
    entropy = new_entropy
    
    cavi.estimate(beta.posterior, global.posterior, active.set)
    em.estimate(beta.posterior, global.posterior)
    
    # exclude probabilities close to 0 or 1 from iteration
    active.set = ((beta.posterior$phi > prob.threshold) &
         (beta.posterior$phi < 1 - prob.threshold))
    
    new_entropy = cal_entropy(beta.posterior$phi, active.set)
    if(max(abs(new_entropy - entropy)) < epsilon) break
  }
  
  return(list(
    beta.posterior = beta.posterior,
    global.posterior = global.posterior
  ))
}
