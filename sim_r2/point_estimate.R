source("simulation_setup.R")
source("generate_data.R")
source("utils.R")
source("update.R")

# main loop
main.loop = function(o){
  beta.posterior = init.beta.posterior()
  global.posterior = init.global.posterior()
  
  new_entropy = rep(0, n.pars)
  active.set = rep(TRUE, n.pars)
  inv.A = solve(
    XTX %*% diag(beta.posterior$phi) + diag(n.pars)/nu1
  )
  
  D = numeric(n.pars)
  B = XTX - diag(diagXTX)
  
  repeat{
    entropy = new_entropy
    
    D = - (beta.posterior$phi)
    
    beta.posterior = cavi.estimate(beta.posterior, global.posterior, inv.A, active.set)
    
    global.posterior = em.estimate(beta.posterior, global.posterior)

    D = D + (beta.posterior$phi)
    
    # exclude probabilities close to 0 or 1 from iteration
    active.set = ((beta.posterior$phi > prob.threshold) &
         (beta.posterior$phi < 1 - prob.threshold))
    
    if(sum(active.set) == 0) break
    inv.A = update.A(inv.A, active.set, B, D)
    
    new_entropy = cal.entropy(beta.posterior$phi, active.set)
    if(max(abs(new_entropy - entropy)) < epsilon) break
    
  }
  
  return(list(
    beta.posterior = beta.posterior,
    global.posterior = global.posterior
  ))
}

