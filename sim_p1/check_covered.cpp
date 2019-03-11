void cavi_implementation::check_covered(){
  int ci_covered_all = 1;
  int cs_covered_all = 1;
  for(int k = 0; k < data.g_vars.K; k++){
    if(
      (bootstrap_ci[k][0] <= data.l_vars.mu[k])
      &&
      (bootstrap_ci[k][1] >= data.l_vars.mu[k])
    ){
      ci_covered_each[k] ++;
    }else ci_covered_all = 0;
  }
  for(int k = 0; k < data.g_vars.K; k++){
    if(
      (credit_set[k][0] <= data.l_vars.mu[k])
      &&
      (credit_set[k][1] >= data.l_vars.mu[k])
    ){
      cs_covered_each[k] ++;
    }else cs_covered_all = 0;
  }

  ci_covered += ci_covered_all;
  cs_covered += cs_covered_all;
  n_experiments ++;
}
