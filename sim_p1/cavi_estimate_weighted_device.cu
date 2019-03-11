__device__
void cavi_implementation::device_generate_weights(){

}

__device__
void cavi_implementation::device_cavi_estimate_weighted(){

}

// for this method we only need vb posterior mean m_k
__global__
void cavi_implementation::device_cavi_bootstrap_update(){
  int tread_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(tread_id >= n_bootstrap) return;

  device_generate_weights(tread_id);

  double device_elbo;
  double device_old_elbo;
}
