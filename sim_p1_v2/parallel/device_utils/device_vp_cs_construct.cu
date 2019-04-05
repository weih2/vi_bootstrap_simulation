__device__ void device_cavi_implementation::device_vp_cs_construct(){
  for(int k = 0; k < K; k++){
    vp_cs[k][0] = -device_ci_quantile * sqrt(s2[k]) + m[k];
    vp_cs[k][1] = device_ci_quantile * sqrt(s2[k]) + m[k];
  }
}
