class device_cavi_implementation{
public:
  __device__ device_cavi_implementation(device_settings&, int);
  int thread_id;

  // global variables
  int K;
  int n_samples;
  double sigma_2;

  // local variables
  double mu[g_vars.K];
  int c[g_vars.n_samples];

  // data
  double x[g_vars.n_samples];
  double weights[g_vars.n_samples];

  // point estimate
  double m[g_vars.K];
  double s2[g_vars.K];
  double phi[g_vars.n_samples][g_vars.K];

  // point estimate per bootstrap sample
  int b_count;
  double m_b[g_vars.K];
  double s2_b[g_vars.K];
  double phi_b[g_vars.n_samples];

  // historical MAP for mu
  double map_mu[n_bootstrap_samples][g_vars.K];

  // intervals
  double vwlb_cs[g_vars.K][2];
  double vp_cs[g_vars.K][2];

  // settings
  int device_n_bootstrap_samples;
  int device_max_n_iter;
  double device_epsilon;
  double device_bootstrap_confidence;
  double device_ci_quantile;

  double elbo;

  __device__ void device_generate_weights();
  __device__ void device_cavi_point_estimate();
  __device__ void device_weighted_cavi_point_estimate();
  __device__ void device_vwlb_cs_construct();
  __device__ void device_vp_cs_construct();

private:
  __device__ void device_cavi_point_estimate_update();
  __device__ void device_weighted_cavi_point_estimate_update();
};
