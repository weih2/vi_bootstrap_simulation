using namespace std;

void cavi_implementation::cs_construct(){
  // const double z_quantile = gsl_cdf_gaussian_Pinv((1 + data.b_vars.confidence) / 2., 1);
  const double z_quantile = cdf_ugaussian_Pinv((1 + data.b_vars.confidence) / 2.);

  credit_set = new double*[data.g_vars.K];

  for(int k = 0; k < data.g_vars.K; k++){
    credit_set[k] = new double[2];
    credit_set[k][0] = -z_quantile * sqrt(est.s2[k]) + est.m[k];
    credit_set[k][1] = z_quantile * sqrt(est.s2[k]) + est.m[k];
  }
}
