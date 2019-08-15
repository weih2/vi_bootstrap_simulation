init.update = function(o){
  cat = sample(1:K, N, replace=T)
  mu = rnorm(K, mean = 0, sd = sqrt(sigma2))
  mu = sort(mu)
  return(list(cat = cat, mu = mu))
}
