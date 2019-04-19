n.pars = 4 # no. covariates
n.obs = 100 # no. obs
auto.cor = 0.1 # collinearity
sigma2 = 1 # error variance
beta = c(2, 3, rep(0, n.pars - 2)) # true beta

# generate one observation
gen.one.obs = function(o){
  as.numeric(
    arima.sim( 
      list(c(1,0,0), # ar(1) model
           ar = auto.cor),
      n = n.pars
    )
  )
}

# generate all observations
gen.all.obs = function(o){
  sapply(1:n.obs, gen.one.obs)
}

# arrange all observations
create.design.matrix = function(o){
  t(gen.all.obs())
}

# generate y, put x and y into the same object
gen.everything = function(){
  X = create.design.matrix()
  noise = rnorm(n.obs, sd = sqrt(sigma2))
  
  y = X %*% beta + noise
  return(list(X = X, y = y))
}
