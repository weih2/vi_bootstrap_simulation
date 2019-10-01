#include "include.cuh"

int main(){
  connector executor();
  executor.run_mcmc(5);
  
  return 0;
}
