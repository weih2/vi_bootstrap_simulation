__device__ void device_cavi_implementation::device_is_outlier(){
  // detect inaccurate point estimate
  double absolute_deviance = 0;
  for(int k = 0; k < K; k++){
    absolute_deviance += fabs(m[k] - mu[k]);
  }

  if(absolute_deviance > 1){
    is_outlier = 1;
  }else is_outlier = 0;

  // is_outlier = 1;

  return;
}
