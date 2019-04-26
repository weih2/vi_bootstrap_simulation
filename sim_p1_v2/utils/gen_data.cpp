using namespace std;

void generate_latent_pars(latent_vars& l_vars){
  l_vars.mu = new double[K];
  l_vars.c = new int[n_samples];

  for(int i = 0; i < K; i++){
    l_vars.mu[i] = 1 * random_normal();
  }

  thrust::sort(l_vars.mu, l_vars.mu + K);

  for(int i = 0; i < n_samples; i++){
    l_vars.c[i] = floor(random_uniform() * K);
  }
  return;
}
