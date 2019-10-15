class device_cavi_implementation{
public:
  __device__ device_cavi_implementation(double, int);
  int thread_id;

  // double sigma_2;

  // local variables
  double mu[N_CLUSTERS];
  int c[n_samples];

  // data
  double x[n_samples];
  double weights[n_samples];

  // point estimate
  double m[N_CLUSTERS];
  double s2[N_CLUSTERS];
  double phi[n_samples][N_CLUSTERS];

  // int is_outlier;

  // point estimate per bootstrap sample
  int b_count;
  double m_b[N_CLUSTERS];
  double s2_b[N_CLUSTERS];
  double phi_b[n_samples][N_CLUSTERS];

  // historical MAP for mu
  double map_mu[N_CLUSTERS][n_bootstrap_samples];

  // outliers excluded
  int n_outliers;
  int is_outlier[n_bootstrap_samples];
  double map_mu_clean[N_CLUSTERS][n_bootstrap_samples];

  // intervals
  double vwlb_cs[N_CLUSTERS][2];
  double vwlb_cs2[N_CLUSTERS][2];
  double vp_cs[N_CLUSTERS][2];

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
  __device__ void device_vwlb_cs2_construct();
  __device__ void device_vp_cs_construct();

private:
  __device__ void device_cavi_point_estimate_update();
  __device__ void device_weighted_cavi_point_estimate_update();
  __device__ void device_is_outlier();
};
