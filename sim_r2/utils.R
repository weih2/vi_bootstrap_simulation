# calculate entropy
cal_entropy = function(probs, active.set){
  probs = probs[active.set]
  entropy = numeric(n.pars)
  entropy[active.set] =  - probs * log(probs) - (1 - probs) * log(1 - probs)
  return(entropy)
}

# parameter initialization
init.global.posterior = function(o){
  global.posterior = list(
    sigma2.hat = 1,
    theta.hat = 1/n.obs
  )
  return(global.posterior)
}

init.beta.posterior = function(o){
  beta.posterior = list(
    mu = numeric(n.pars),
    s2 = rep(1, n.pars),
    phi = rep(1, n.pars)
  )
  return(beta.posterior)
}
