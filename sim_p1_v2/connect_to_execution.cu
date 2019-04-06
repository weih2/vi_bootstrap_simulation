void bridge::connect_to_execution(){
  cavi_execute<<<64,64>>>(*this, 1);
  cudaDeviceSynchronize();
  count_coverage();
  cudaDeviceSynchronize();
}
