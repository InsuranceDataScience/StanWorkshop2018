data {
  int<lower=1> N;
  vector[N] quality;
  vector[N] alcohol;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 10);    
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 2.5);
  quality ~ normal(alpha + beta * alcohol, sigma);
}
generated quantities {
  vector[N] q_rep;
  for(n in 1:N) {
    q_rep[n] = normal_rng(alpha + beta * alcohol[n], sigma);
  }
}
