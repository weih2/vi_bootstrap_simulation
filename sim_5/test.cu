#include "include.cuh"

int main(){
  connector executor = connector();
  executor.run_mcmc(2);
  executor.gen_stats();
  executor.print_stats();
  executor.print_cov();

  return 0;
}
