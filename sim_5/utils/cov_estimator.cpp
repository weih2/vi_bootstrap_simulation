#include <lapacke.h>

void cov_estimator(double* inv_fi, double* diag_fi){
  LAPACKE_dpotrf(LAPACK_ROW_MAJOR, 'U', N_CENTERS, inv_fi, N_CENTERS);
  LAPACKE_dpotri(LAPACK_ROW_MAJOR, 'U', N_CENTERS, inv_fi, N_CENTERS);

  for(int k = 0; k < N_CENTERS; k++){
    diag_fi[k] = inv_fi[k*N_CENTERS + k];
  }
}
