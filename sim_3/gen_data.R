# basic setting
sigma2 = 30

K = 3
N = 100

# true parameters

delta = 5
mu0 = c(- delta, 0, delta)

gen.new.data = function(o){
  cat0 <<- sample(1:K, N, replace=T)
  x <<- mu0[cat0] + rnorm(N)
}

