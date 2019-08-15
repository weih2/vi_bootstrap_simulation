gibbs.sample = function(old.sample){
  new.sample = list()
  # sample categories
  # categorical
  new.sample$cat = 
    apply(exp(-outer(x, old.sample$mu, "-")^2/2), 1, function(prob){
      prob = prob/sum(prob)
      sample.int(3, size = 1, prob = prob)
    })
  # sample global
  new.sample$mu = numeric(K)
  for(k in 1:K){
    var.mu = sigma2/(1 + sigma2 * sum(new.sample$cat == k))
    new.sample$mu[k] = rnorm(1, mean = var.mu * sum(x * (new.sample$cat == k)), sd = sqrt(var.mu))
  }
  new.sample$mu = sort(new.sample$mu)
  return(new.sample)
}
