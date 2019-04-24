class device_cavi_implementation{
public:
  __device__ device_cavi_implementation(device_settings, int);
  int thread_id;

  // local variables
  double mu[K];
  int c[n_samples];

  // data
  double x[n_samples];
  double weights[n_samples];

  // point estimate
  double m[K];
  double s2[K];
  double phi[n_samples][K];

  // point estimate per bootstrap sample
  int b_count;
  double m_b[K * 2];
  double s2_b[K];
  double phi_b[n_samples][K];

  // historical MAP for mu
  double map_mu[K][n_bootstrap_samples];

  // intervals
  double vwlb_cs[K][2];
  double vwlb_cs2[K][2];
  double vp_cs[K][2];

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
  __device__ void device_weighted_cavi_point_estimate_update(int);
};
