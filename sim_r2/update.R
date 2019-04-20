library(gtools) # will provide logit and inv.logit

cavi.estimate = function(beta.posterior, global.posterior, active.set){
  
  beta.posterior[active.set] = inv.logit(
    logit(global.posterior$theta.hat) + 
      log(beta.posteior$s2[active.set]/(nu1 * global.posterior$sigma2.hat)) +
      beta.posterior$mu^2 / (2 * beta.posterior$s2)
  )
}

em.estimate = function(beta.posterior, global.posterior){
  global.posterior$theta.hat = 
    (sum(beta.posterior$phi) + a0 - 1)/
    (n.pars + a0 + b0 - 2)
  global.posterior$sigma2.hat = ( 
    nu * lambda + 
    sum((y - X %*% (beta.posterior$phi * beta.posterior$mu))^2) +
    sum(
      (diag(XTX) * (1 - beta.posterior$phi) + 1/nu1) * 
        beta.posterior$phi * beta.posterior$mu^2
    ) +
    sum(
      (diag(XTX) + 1/nu1) *
        beta.posterior$phi * beta.posterior$s2
    )
  ) / (n.obs + sum(beta.posterior$phi) + nu + 2)
  return(global.posterior)
}