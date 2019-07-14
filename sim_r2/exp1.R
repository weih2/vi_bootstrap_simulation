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
  empirical.covered = 0
  
  vwlb.ci1.covered.2 = 0
  vwlb.ci2.covered.2 = 0
  vp.cs.covered.2 = 0
  empirical.covered.2 = 0
  
  point.estimates = numeric(0)
  point.estimates.2 = numeric(0)
  
  for(i in 1:n.experiments){
    original.data <<- gen.new.y(original.data)
    XTX <<- t(original.data$X) %*% (original.data$X)
    diagXTX <<- diag(XTX)
    XTy <<- t(original.data$X) %*% (original.data$y)
    
    point.estimate.beta = main.loop()$beta.posterior
    point.estimates = c(point.estimates, point.estimate.beta$mu[1])
    point.estimates.2 = c(point.estimates.2, point.estimate.beta$mu[2])
    
    if(i %% 10 == 0) print(i)
    ci.results = get.beta1.vwlb.cs(original.data, 0.95)
    vwlb.ci1 = ci.results$vwlb.ci1
    vwlb.ci2 = ci.results$vwlb.ci2
    vwlb.ci1.2 = ci.results$vwlb.ci1.2
    vwlb.ci2.2 = ci.results$vwlb.ci2.2
    vp.cs = vb.beta1.credential.set(point.estimate.beta, 0.95)
    vp.cs.2 = vb.beta2.credential.set(point.estimate.beta, 0.95)
    
    # print(vwlb.cs[1]); print(vwlb.cs[2])
    if(
      (vwlb.ci1[1] < beta[1])&
      (vwlb.ci1[2] > beta[1])
    ) vwlb.ci1.covered = vwlb.ci1.covered + 1
    
    if(
      (vwlb.ci1.2[1] < beta[2])&
      (vwlb.ci1.2[2] > beta[2])
    ) vwlb.ci1.covered.2 = vwlb.ci1.covered.2 + 1
    
    if(
      (vwlb.ci2[1] < beta[1])&
      (vwlb.ci2[2] > beta[1])
    ) vwlb.ci2.covered = vwlb.ci2.covered + 1
    
    if(
      (vwlb.ci2.2[1] < beta[2])&
      (vwlb.ci2.2[2] > beta[2])
    ) vwlb.ci2.covered.2 = vwlb.ci2.covered.2 + 1
    
    if(
      (vp.cs[1] < beta[1])&
      (vp.cs[2] > beta[1])
    ) vp.cs.covered = vp.cs.covered + 1
    
    if(
      (vp.cs.2[1] < beta[2])&
      (vp.cs.2[2] > beta[2])
    ) vp.cs.covered.2 = vp.cs.covered.2 + 1
  }
  
  empirical.sd = sd(point.estimates)
  empirical.covered = sum(
    empirical.sd * qnorm(0.5 + 0.95/2) > abs(point.estimates - beta[1])
  )
  
  empirical.sd.2 = sd(point.estimates.2)
  empirical.covered.2 = sum(
    empirical.sd.2 * qnorm(0.5 + 0.95/2) > abs(point.estimates.2 - beta[2])
  )
  
  return(
    c(vwlb.ci1.covered, vwlb.ci2.covered, vp.cs.covered, empirical.covered,
      vwlb.ci1.covered.2, vwlb.ci2.covered.2,
      vp.cs.covered.2, empirical.covered.2
      )
    
    )
}

result = matrix(nrow = 0, ncol = 9)
for(i in 0:19){
  auto.cor <<- 0.05 * i
  original.data <<- gen.everything()
  result = rbind(result, c(test.coverage(), auto.cor))
  # result = rbind(result, test.coverage())
}

show(result)
