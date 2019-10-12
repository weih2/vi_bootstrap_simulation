void cov_estimator(double* inv_fi, double* diag_fi){
  Matrix<double, N_CENTERS, N_CENTERS> libeigen_mat
    (Map<Matrix<double, N_CENTERS, N_CENTERS> >(inv_fi));

  libeigen_mat = libeigen_mat.inverse();

  for(int k = 0; k < N_CENTERS; k ++)
    diag_fi[k] = libeigen_mat(k,k);
}
