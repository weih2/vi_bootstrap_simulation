## compute true ratio through Monte Carlo simulation


true.ratio.mc = function(n.samples = 10^6){ # default one million samples
  N <<- n.samples
  gen.new.data()
  
  # compute latent posterior at true global parameter
  latent.posterior = apply(exp(-outer(x, mu0, "-")^2/2), 1, function(prob){
    prob/sum(prob)
  })
  
  # estimate Fisher info
  score.est = latent.posterior * outer(mu0, x, "-")
  diag.Fisher.info.est = apply( score.est ^2 , 1, mean)
  
  # estimate latent info
  diag.latent.info.est = apply(
    latent.posterior + 
      latent.posterior *
      (
        - 1 + outer(mu0, x, "-")^2
      ) -
      latent.posterior^2 *
      (outer(mu0, x, "-")^2),
    1, mean)
  
  # true ratio
  (diag.Fisher.info.est + diag.latent.info.est)/diag.Fisher.info.est
}

sapply( rep(10^6, 10), true.ratio.mc)
