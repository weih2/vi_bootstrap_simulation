void bridge::connect_to_execution(){
  cavi_execute<<<64,64>>>(this);
}
