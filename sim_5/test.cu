#include "include.cuh"

int main(){
  connector executor = connector();
  executor.run_mcmc(5);

  return 0;
}
