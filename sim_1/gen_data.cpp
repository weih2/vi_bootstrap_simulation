using namespace std;

void generate_latent_pars(simulation_data& sim_data){
  sim_data.l_vars.mu = new double[sim_data.g_vars.K];
  sim_data.l_vars.c = new double[sim_data.g_vars.n_samples];

  for(int i = 0; i < sim_data.g_vars.K; i++){
    sim_data.l_vars.mu[i] = sqrt(sim_data.g_vars.sigma_2) * random_normal();
  }

  for(int i = 0; i < sim_data.g_vars.n_samples; i++){
    sim_data.l_vars.c[i] = round(random_uniform() * sim_data.g_vars.K);
  }
  return;
}

void generate_data(simulation_data& sim_data){
  sim_data.x = new double[sim_data.g_vars.n_samples];

  for(int i = 0; i < sim_data.g_vars.n_samples; i++){
    const int &i_cat = sim_data.l_vars.c[i];
    sim_data.x[i] = sim_data.l_vars.mu[i_cat] + random_normal();
  }
  return;
}

void generate_weights(simulation_data& sim_data){
  static int allocated = 0;
  if(!allocated){
    sim_data.b_vars.weights = new double[sim_data.g_vars.n_samples];
    allocated = 1;
  }

  // generate exponential weigths only

  for(int i = 0; i < sim_data.g_vars.n_samples ; i++){
    sim_data.b_vars.weights[i] = - log(random_uniform());
  }

  return;
}
