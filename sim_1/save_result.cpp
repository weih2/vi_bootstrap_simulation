using namespace std;

void cavi_implementation::save_result(const string& file_name){
  ofstream result_stream;
  result_stream.open(file_name);
  // saving true value
  result_stream << "true mu's are:" << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << data.l_vars.mu[k];
  }

  result_stream.close();
}
