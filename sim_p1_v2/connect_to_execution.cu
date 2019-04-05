void bridge::connect_to_execution(){
  cavi_execute<<<64,64>>>(*this, 1);
  cudaDeviceSynchronize();
  for(int n = 0; n < n_experiments; n++){
    cavi_execute<<<64,64>>>(*this, 0);
    cudaDeviceSynchronize();
    construct_empirical_ci();

    for(int k = 0; k < K; k++){
      if((empirical_ci[k][0] < host_dev_settings.l_vars.mu[k])
        &&(empirical_ci[k][1] > host_dev_settings.l_vars.mu[k]))
        empirical_ci_covered_counts[k]++;
    }
  }
}
