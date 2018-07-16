data {
  int<lower=1> N;
  int<lower=1> K;
  vector[N] y;
  matrix[N, K] X;
}
parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 10);    
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 2.5);
  y ~ normal(alpha + X * beta, sigma);
}
generated quantities {
  vector[N] y_rep;
  for(n in 1:N) {
    y_rep[n] = normal_rng(alpha + X[n, ] * beta, sigma);
  }
}
