check.covered <- function(credit.interval){
  return((mu0 >= credit.interval[1,]) & (mu0<= credit.interval[2,] ))
}
