void cavi_implementation::check_covered(){
  for(int k = 0; k < data.g_vars.K; k++){
    if(
      (bootstrap_ci[k][0] > data.l_vars.mu[k])
      ||
      (bootstrap_ci[k][1] < data.l_vars.mu[k])
    ){
      ci_covered --;
      break;
    }
  }
  for(int k = 0; k < data.g_vars.K; k++){
    if(
      (credit_set[k][0] > data.l_vars.mu[k])
      ||
      (credit_set[k][1] < data.l_vars.mu[k])
    ){
      cs_covered --;
      break;
    }
  }

  ci_covered ++;
  cs_covered ++;
  n_experiments ++;
}
