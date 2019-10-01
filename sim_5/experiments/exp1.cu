#include "../include.cuh"

int main(){
  double test_seq;

  connector executor = connector();

  for(int m = 0; m < 51; m++){
    test_seq = m>0? (test_seq * exp(0.1)):exp(-3);

    executor.run_mcmc(test_seq);
    executor.gen_stats();
    executor.print_stats();
  }
}
