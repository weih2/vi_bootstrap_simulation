void generate_x(double *x, double auto_correlation = 0){
  for(i = 0; i < n; i++){
    x[i * p] = random_normal();
    for(k = 1; k < p; k++){
      x[i * p + k] =
        x[i * p + k - 1] * auto_correlation
        + random_normal() * sqrt(1 - auto_correlation * auto_correlation);
    }
  }
}
