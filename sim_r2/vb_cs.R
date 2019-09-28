vb.beta1.credential.set = function(beta.posterior, confidence){
  # remaining prob excluding the point mass at 0
  re.prob = confidence - 1 + beta.posterior$phi[1]
  
  if(re.prob < 0) return(c(0,0))
  
  # posterior (beta < 0)
  posterior.nagetive = 
    pnorm( - (beta.posterior$mu[1])/sqrt(beta.posterior$s2[1]))
  
  if(2 * posterior.nagetive < 1 - re.prob){
    return(
      c(0,
        qnorm( re.prob + posterior.nagetive, 
              mean = beta.posterior$mu[1],
              sd = sqrt(beta.posterior$s2[1])))
    )
  }
  
  if(2 - 2 * posterior.nagetive < 1 - re.prob){
    return(
      c( qnorm( posterior.nagetive - re.prob,
          mean = beta.posterior$mu[1],
          sd = sqrt(beta.posterior$s2[1])
          ),
       0)
    )
  }
  
  # quantile standard normal
  q.std = qnorm((1 + re.prob)/2)
  
  return(c(
    beta.posterior$mu[1] - q.std * sqrt(beta.posterior$s2[1]),
    beta.posterior$mu[1] + q.std * sqrt(beta.posterior$s2[1])
  )
  )
}

vb.credible.set = function(beta.posterior, confidence, beta.index){
  # remaining prob excluding the point mass at 0
  re.prob = confidence - 1 + beta.posterior$phi[beta.index]
  
  if(re.prob < 0) return(c(0,0))
  tail.prob = (1 - confidence)/2
  
  q.std = qnorm(1 - tail.prob)
  
  temp.cs = c(beta.posterior$mu[beta.index] - q.std * sqrt(beta.posterior$s2[beta.index]),
              beta.posterior$mu[beta.index] + q.std * sqrt(beta.posterior$s2[beta.index]))
  
  if ( (temp.cs[1] < 0)&&(temp.cs[2] > 0) ){
    rev.tail.prob = ( 1 - re.prob )/2
    q.std = qnorm(1 - rev.tail.prob)
    temp2 = beta.posterior$mu[beta.index] - q.std * sqrt(beta.posterior$s2[beta.index])
    temp3 = beta.posterior$mu[beta.index] + q.std * sqrt(beta.posterior$s2[beta.index])
    if((temp2 < 0)&&(temp3 > 0)) temp.cs = c(temp2, temp3)
    else if(temp2 > 0) temp.cs[1] = 0
    else temp.cs[2] = 0
  }
  
  return(temp.cs)
}

vb.beta2.credential.set = function(beta.posterior, confidence){
  # remaining prob excluding the point mass at 0
  re.prob = confidence - 1 + beta.posterior$phi[2]
  
  if(re.prob < 0) return(c(0,0))
  
  # posterior (beta < 0)
  posterior.nagetive = 
    pnorm( - (beta.posterior$mu[2])/sqrt(beta.posterior$s2[2]))
  
  if(2 * posterior.nagetive < 1 - re.prob){
    return(
      c(0,
        qnorm( re.prob + posterior.nagetive, 
               mean = beta.posterior$mu[2],
               sd = sqrt(beta.posterior$s2[2])))
    )
  }
  
  if(2 - 2 * posterior.nagetive < 1 - re.prob){
    return(
      c( qnorm( posterior.nagetive - re.prob,
                mean = beta.posterior$mu[2],
                sd = sqrt(beta.posterior$s2[2])
      ),
      0)
    )
  }
  
  # quantile standard normal
  q.std = qnorm((1 + re.prob)/2)
  
  return(c(
    beta.posterior$mu[2] - q.std * sqrt(beta.posterior$s2[2]),
    beta.posterior$mu[2] + q.std * sqrt(beta.posterior$s2[2])
  )
  )
}
