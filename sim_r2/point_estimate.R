# main loop
main.loop = function(o){
  beta.posterior = init.beta.posterior()
  global.posterior = init.global.posterior()
  
  new_entropy = rep(0, n.pars)
  active.set = rep(TRUE, n.pars)
  
  repeat{
    entropy = new_entropy
    
    beta.posterior = cavi.estimate(beta.posterior, global.posterior, active.set)
    global.posterior = em.estimate(beta.posterior, global.posterior)
    
    # exclude probabilities close to 0 or 1 from iteration
    active.set = ((beta.posterior$phi > prob.threshold) &
         (beta.posterior$phi < 1 - prob.threshold))
    
    new_entropy = cal.entropy(beta.posterior$phi, active.set)
    if(max(abs(new_entropy - entropy)) < epsilon) break
  }
  
  return(list(
    beta.posterior = beta.posterior,
    global.posterior = global.posterior
  ))
}
