theme_set(theme_bw())

# just the points
sleepstudy$cond <- paste0(
  "Subject = ", sleepstudy$Subject
)

ggplot(sleepstudy, aes(Days, Reaction)) +
  geom_point() + 
  facet_wrap("cond", nrow = 3)

ggsave("graphics/sleepstudy_points.jpeg", width = 8, height = 5)

# predictions
fit_sleep2 <- brm(Reaction ~ Days + (Days|Subject),
                  data = sleepstudy)

conds <- make_conditions(fit_sleep2, "Subject")

fit_sleep2 %>%
  marginal_effects(
    re_formula = NULL, 
    conditions = conds
  ) %>%
  plot(points = TRUE, ncol = 6)

ggsave("graphics/sleepstudy_preds.jpeg", width = 8, height = 5)
