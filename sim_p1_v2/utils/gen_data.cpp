using namespace std;

void generate_latent_pars(latent_vars& l_vars){
  l_vars.mu = new double[g_vars.K];
  l_vars.c = new int[g_vars.n_samples];

  for(int i = 0; i < g_vars.K; i++){
    l_vars.mu[i] = sqrt(g_vars.sigma_2) * random_normal();
  }

  thrust::sort(l_vars.mu, l_vars.mu + g_vars.K);

  for(int i = 0; i < g_vars.n_samples; i++){
    l_vars.c[i] = floor(random_uniform() * g_vars.K);
  }
  return;
}
