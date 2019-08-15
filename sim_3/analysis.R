
sigma2.means = c()
for(i in 1:4) sigma2.means = c(sigma2.means, log(mean(sigma.mcmc[1:50 %% 5 == i,])))
sigma2.means = c(sigma2.means, log(mean(sigma.mcmc[1:50 %% 5 == 0,])))
x.axis = log(c(100, 200, 500, 1000, 2000))

sigma.mcmc[1:50 %% 5 == 1,]
sigma.mcmc[1:50 %% 5 == 2,]
sigma.mcmc[1:50 %% 5 == 3,]
sigma.mcmc[1:50 %% 5 == 4,]
sigma.mcmc[1:50 %% 5 == 5,]