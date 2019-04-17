void bridge::lengths_copy_back(){
  cudaMemcpy(vwlb_cs_lengths, device_vwlb_cs_lengths,
    sizeof(double) * K * n_experiments, cudaMemcpyDeviceToHost);
  cudaMemcpy(vwlb_cs2_lengths, device_vwlb_cs2_lengths,
    sizeof(double) * K * n_experiments, cudaMemcpyDeviceToHost);
  cudaMemcpy(vp_cs_lengths, device_vp_cs_lengths,
    sizeof(double) * K * n_experiments, cudaMemcpyDeviceToHost);
}
