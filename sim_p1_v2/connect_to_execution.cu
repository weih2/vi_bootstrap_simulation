void bridge::connect_to_execution(){
  cavi_execute<<<32,32>>>(*this, 1);
  cudaDeviceSynchronize();
  count_coverage();
  cudaDeviceSynchronize();
}

void bridge::connect_to_analysis(){
  cavi_execute<<<32,32>>>(*this, 2);
  cudaDeviceSynchronize();
  count_coverage();
  lengths_copy_back();
  cudaDeviceSynchronize();
}
