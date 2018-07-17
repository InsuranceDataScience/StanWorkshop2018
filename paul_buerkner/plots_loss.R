url <- "https://raw.githubusercontent.com/mages/diesunddas/master/Data/ClarkTriangle.csv"
loss <- read.csv(url)
loss$AY <- factor(loss$AY)
loss$LR <- with(loss, cum / premium)

ggplot(loss, aes(dev, cum)) +
  geom_point() +
  facet_wrap("AY", nrow = 2)

ggsave("graphics/loss_points.jpeg", width = 8, height = 5)

ggplot(loss, aes(dev, LR)) +
  geom_point() +
  facet_wrap("AY", nrow = 2)

ggsave("graphics/loss_ratio_points.jpeg", width = 8, height = 5)


# fitting a non-linear gausian model in brms
bform_lin <- bf(
  LR ~ ulr * (1 - exp(-(dev/theta)^omega)),
  ulr ~ 1 + (1|AY), omega ~ 1, theta ~ 1, 
  nl = TRUE
)

bprior_lin <- 
  prior(lognormal(log(0.5), log(1.4)), nlpar = "ulr", lb = 0) + 
  prior(normal(1, 2), nlpar = "omega", lb = 0) +
  prior(normal(45, 10), nlpar = "theta", lb = 0)

fit_LR_lin <- brm(bform_lin, data = loss, prior = bprior_lin)

conds <- make_conditions(fit_LR_lin, "AY")
fit_LR_lin %>%
  marginal_effects(
    re_formula = NULL, 
    conditions = conds,
    method = "predict"
  ) %>%
  plot(points = TRUE, ncol = 5)

ggsave("graphics/loss_ratio_preds.jpeg", width = 8, height = 5)


# fitting a non-linear lognormal model in brms
bform_loglin <- bf(
  LR ~ log(ulr * (1 - exp(-(dev/theta)^omega))),
  ulr ~ 1 + (1|AY), omega ~ 1, theta ~ 1, 
  nl = TRUE
)

bprior_loglin <- 
  prior(lognormal(log(0.5), log(1.4)), nlpar = "ulr", lb = 0) + 
  prior(normal(1, 2), nlpar = "omega", lb = 0) +
  prior(normal(45, 10), nlpar = "theta", lb = 0)

fit_LR_loglin <- brm(
  bform_loglin, data = loss, 
  family = lognormal(), prior = bprior_loglin
)

conds <- make_conditions(fit_LR_loglin, "AY")
fit_LR_loglin %>%
  marginal_effects(
    re_formula = NULL, 
    conditions = conds,
    method = "predict"
  ) %>%
  plot(points = TRUE, ncol = 5)

ggsave("graphics/loss_ratio_loglin_preds.jpeg", width = 8, height = 5)
