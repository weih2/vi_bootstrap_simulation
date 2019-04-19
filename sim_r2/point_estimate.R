data = gen.everything() 

# cavi settings
n.max.iter = 20
epsilon = 1e-3
prob.threshold = 1e-6

XTX = t(data$X) %*% (data$X)
XTy = t(data$X) %*% (data$y)

cavi.estimate = function(beta.posterior, global.posterior, active_set){
  beta.posterior$
}

em.estimate = function(beta.posterior, global.posterior){
  
}

# main loop
main.loop = function(o){
  beta.posterior = init.beta.posterior()
  global.posterior = init.global.posterior()
  
  new_entropy = rep(0, n.pars)
  active_set = rep(TRUE, n.pars)
  
  repeat{
    entropy = new_entropy
    
    cavi.estimate(beta.posterior, global.posterior, active_set)
    em.estimate(beta.posterior, global.posterior)
    
    # exclude probabilities close to 0 or 1 from iteration
    active_set = ((beta.posterior$phi > prob.threshold) &
         (beta.posterior$phi < 1 - prob.threshold))
    
    new_entropy = cal_entropy(beta.posterior$phi, active_set)
    if(max(abs(new_entropy - entropy)) < epsilon) break
  }
  
  return(list(
    beta.posterior = beta.posterior,
    global.posterior = global.posterior
  ))
}
