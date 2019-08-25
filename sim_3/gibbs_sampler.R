gibbs.sample = function(old.sample){
  new.sample = list()
  # sample categories
  # categorical
  new.sample$cat = 
    apply(exp(-outer(x, old.sample$mu, "-")^2/2), 1, function(prob){
      prob = prob/sum(prob)
      sample.int(3, size = 1, prob = prob)
    })
  # sample global
  new.sample$mu = numeric(K)
  for(k in 1:K){
    var.mu = sigma2/(1 + sigma2 * sum(new.sample$cat == k))
    new.sample$mu[k] = rnorm(1, mean = var.mu * sum(x * (new.sample$cat == k)), sd = sqrt(var.mu))
  }
  new.sample$mu = sort(new.sample$mu)
  return(new.sample)
}

gibbs.sampler.cxx.body = '
  #define SIGMA_2 25.
  
  List old_sample = as<List>(oldSample);
  arma::Col<int> old_c = old_sample["cat"];
  arma::rowvec old_mu = old_sample["mu"];
  
  arma::colvec data_x = as<NumericVector>(x);
  
  int K = old_mu.size();
  int N = data_x.size();
  arma::Col<int> new_c(old_c);
  arma::rowvec new_mu(old_mu);
  
  arma::mat prob_mat(N, K);
  
  arma::Row<int> cat_k_count(K);
  arma::rowvec cat_k_sum(K);
  
  int n_iter = as<int>(nSteps);
  
  arma::colvec ru(N);
  arma::rowvec rn(K);
  double var_mu;
  
  for(int n_iter_current = 0; n_iter_current < n_iter; n_iter_current++){
    for(int k = 0; k < K; k ++){
      prob_mat.col(k) = data_x - new_mu[k];
    }
    
    
    prob_mat = exp( - prob_mat % prob_mat /2) ;
    
    // sample latent
    ru.randu();
    for(int n = 0; n < N; n++){
      prob_mat.row(n) /= sum(prob_mat.row(n));
      for(int k = 0; k < K; k++){
        if(ru[n] < prob_mat.at(n,k)){
          new_c[n] = k;
          break;
        }
        ru[n] -= prob_mat.at(n,k);
      }
    }
    
    for(int k = 0; k < K; k++){
      cat_k_count[k] = cat_k_sum[k] = 0;
    }
    
    // sample global
    for(int n = 0; n < N; n++){
      cat_k_count[new_c[n]] ++;
      cat_k_sum[new_c[n]] += data_x[n];
    }
    
    rn.randn();
    for(int k = 0; k < K; k++){
      var_mu = SIGMA_2 / (1 + cat_k_count[k] * SIGMA_2);
      new_mu[k] = var_mu * cat_k_sum[k] + rn[k] * sqrt(var_mu);
    }
    new_mu = sort(new_mu);
  }

  return wrap(List::create(
    _["cat"] = new_c,
    _["mu"] = new_mu
  ));
'

# library(inline)
gibbs.sampler.cxx = cxxfunction(
  signature(x = "numeric", oldSample = "ANY", nSteps = "integer"),
  gibbs.sampler.cxx.body,
  plugin = "RcppArmadillo"
)
