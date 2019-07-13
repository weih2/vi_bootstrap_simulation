source("simulation_setup.R")
source("vwlb_estimate.R")
source("vb_cs.R")

n.experiments = 1000
n.b.samples = 500

data = gen.everything() # only a place holder
original.data = data

test.coverage = function(o){
  vwlb.ci1.covered = 0
  vwlb.ci2.covered = 0
  vp.cs.covered = 0
  
  for(i in 1:n.experiments){
    original.data <<- gen.new.y(original.data)
    XTX <<- t(original.data$X) %*% (original.data$X)
    diagXTX <<- diag(XTX)
    XTy <<- t(original.data$X) %*% (original.data$y)
    
    
    beta1.bootstrap.map = numeric(0)
    point.estimate.beta = main.loop()$beta.posterior
    if(i %% 10 == 0) print(i)
    vwlb.ci1 = get.beta1.vwlb.cs(original.data, 0.95)$vwlb.ci1
    vwlb.ci2 = get.beta1.vwlb.cs(original.data, 0.95)$vwlb.ci2
    vp.cs = vb.beta1.credential.set(point.estimate.beta, 0.95)
    
    # print(vwlb.cs[1]); print(vwlb.cs[2])
    if(
      (vwlb.ci1[1] < beta[1])&
      (vwlb.ci1[2] > beta[1])
    ) vwlb.ci1.covered = vwlb.ci1.covered + 1
    
    if(
      (vwlb.ci2[1] < beta[1])&
      (vwlb.ci2[2] > beta[1])
    ) vwlb.ci2.covered = vwlb.ci2.covered + 1
    
    if(
      (vp.cs[1] < beta[1])&
      (vp.cs[2] > beta[1])
    ) vp.cs.covered = vp.cs.covered + 1
  }
  
  return(c(vwlb.ci1.covered, vwlb.ci2.covered, vp.cs.covered))
}

result = matrix(nrow = 0, ncol = 3)
for(i in 0:9){
  auto.cor <<- 0.1 * i
  original.data <<- gen.everything()
  result = rbind(result, test.coverage())
}

show(result)
