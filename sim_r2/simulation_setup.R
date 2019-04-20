data = gen.everything() 

# cavi settings
n.max.iter = 20
epsilon = 1e-3
prob.threshold = 1e-6

# prior parameters
# prior parameters for theta, will be uniform(0, 1)
a0 = 1
b0 = 1
# prior parameters for sigma2, will be IG(0.001, 0.001)
nu = 0.002
lambda = 1
# hyper parameter set fixed
nu1 = 1

XTX = t(data$X) %*% (data$X)
diagXTX = diag(XTX)
XTy = t(data$X) %*% (data$y)
