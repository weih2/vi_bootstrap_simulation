library(gtools) # will provide logit and inv.logit

update.A = function(inv.A, active.set, B, D){
  inv.A = inv.A - inv.A %*% B[, active.set] %*%
    solve(
      diag(1/D[active.set]) + inv.A[active.set, ] %*% B[, active.set]
    ) %*% 
    inv.A[active.set, ]
  return(inv.A)
}

update.A.slow = function(beta.posterior){
  return(
    solve(
      XTX %*% diag(beta.posterior$phi) + 
        diag(diagXTX * (1 - beta.posterior$phi)) + diag(n.pars)/nu1
    )
  )
}

cavi.estimate = function(beta.posterior, global.posterior, inv.A, active.set){
  beta.posterior$mu = inv.A %*% XTy
  beta.posterior$s2 = global.posterior$sigma2.hat / (diagXTX + 1/nu1)
  beta.posterior$phi[active.set] = inv.logit(
    logit(global.posterior$theta.hat) + 
      log(beta.posterior$s2[active.set]/(nu1 * global.posterior$sigma2.hat)) +
      (beta.posterior$mu[active.set])^2 / (2 * beta.posterior$s2[active.set])
  )
  return(beta.posterior)
}

em.estimate = function(beta.posterior, global.posterior){
  global.posterior$theta.hat = 
    (sum(beta.posterior$phi) + a0 - 1)/
    (n.pars + a0 + b0 - 2)

  global.posterior$sigma2.hat = ( 
    nu * lambda + 
    sum((data$y - data$X %*% (beta.posterior$phi * beta.posterior$mu))^2) +
    sum(
      (diagXTX * (1 - beta.posterior$phi) + 1/nu1) * 
        beta.posterior$phi * (beta.posterior$mu)^2
    ) +
    sum(
      (diagXTX + 1/nu1) *
        beta.posterior$phi * beta.posterior$s2
    )
  ) / (n.obs + sum(beta.posterior$phi) + nu + 2)
  return(global.posterior)
}
