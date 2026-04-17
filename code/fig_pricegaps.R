library(data.table)
library(ggplot2)
library(ggpattern)

# ---- Data from Table 1 ----
# NA where the table shows "---" or blank. Knee MRI private = midpoint of $606-919.
d <- data.table(
  service = c(
    # Panel A
    "Eliquis, 30-day",
    "Stelara, 30-day eq.",
    "Humalog, 100 units",
    # Panel B
    "Chest X-ray, 2 views",
    "Three CT scans",
    "Nuclear stress test",
    "Flebogamma, per dose",
    "Appendectomy",
    "Partial hip replacement",
    "Heart attack, 4 stents",
    "Colonoscopy with biopsy",
    # Panel C
    "Knee MRI",
    "Routine blood panel",
    "Sleep study, 1 night",
    "Prenatal blood panel",
    "Allergy skin panel",
    "ER trauma activation",
    "Oxaliplatin, per infusion"
  ),
  panel = c(
    rep("A. Pharmaceuticals", 3),
    rep("B. Hospital services", 8),
    rep("C. Physician & outpatient services", 7)
  ),
  VA       = c(344, 4993, 2.51,
               NA, NA, NA, NA, NA, NA, 25000, 880,
               NA, NA, 790, NA, NA, NA, 830),
  Medicare = c(231, 4695, NA,
               20.44, 825, 554, 2123, NA, NA, NA, 1760,
               200, 32, 920, 45, 300, 2000, 3090),
  Private  = c(309, 7860, NA,
               60, NA, 2038, NA, 8944, 70882, NA, 5816,
               762, 43, 5419, 6701, 24400, 3431, 3616),
  Uninsured = c(521, 13836, 8.50,
                283, 6538, 7998, 4615, 41212, 117000, 164941, 19206,
                2800, 500, 10322, 9520, 24400, 18836, 6711)
)

# Keep only services with >= 3 non-NA payer values
d[, nvals := rowSums(!is.na(.SD)), .SDcols = c("VA", "Medicare", "Private", "Uninsured")]
d <- d[nvals >= 3]
d[, nvals := NULL]

# Melt to long
long <- melt(d, id.vars = c("service", "panel"),
             variable.name = "payer", value.name = "price")
long <- long[!is.na(price)]

# Factor ordering
service_order <- d$service
long[, service := factor(service, levels = service_order)]
payer_order <- c("VA", "Medicare", "Private", "Uninsured")
long[, payer := factor(payer, levels = payer_order)]

# Grayscale + pattern encoding for the four payers
# VA:       solid light gray
# Medicare: diagonal stripes, medium gray
# Private:  crosshatch, dark gray
# Uninsured: solid black
pattern_values  <- c(VA = "none",      Medicare = "stripe", Private = "crosshatch", Uninsured = "none")
fill_values     <- c(VA = "gray15",    Medicare = "gray60", Private = "gray40",     Uninsured = "gray85")
pcolor_values   <- c(VA = "gray15",    Medicare = "black",  Private = "black",      Uninsured = "gray85")
pfill_values    <- c(VA = "gray15",    Medicare = "gray90", Private = "gray85",     Uninsured = "gray85")

size1 <- 14

p <- ggplot(long, aes(x = payer, y = price, fill = payer, pattern = payer,
                       pattern_fill = payer, pattern_colour = payer)) +
  geom_col_pattern(
    width = 0.75,
    color = "black",
    pattern_density = 0.45,
    pattern_spacing = 0.05,
    pattern_angle   = 45,
    pattern_key_scale_factor = 0.8
  ) +
  facet_wrap(~ service, scales = "free_y", ncol = 4) +
  scale_pattern_manual(values = pattern_values, guide = "none") +
  scale_fill_manual(values = fill_values, guide = "none") +
  scale_pattern_fill_manual(values = pfill_values, guide = "none") +
  scale_pattern_colour_manual(values = pcolor_values, guide = "none") +
  labs(x = NULL, y = "Price (USD)") +
  theme_minimal(base_size = size1) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = size1),
    axis.text.y = element_text(size = size1),
    axis.title = element_text(size = size1),
    strip.text = element_text(face = "bold", size = size1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.spacing.x = unit(1.0, "lines"),
    panel.spacing.y = unit(1.2, "lines"),
    plot.margin = margin(5, 10, 5, 5)
  )

ggsave("f:/GDrive/16_pharma_reform_proposal/latex/fig_pricegaps.pdf",
       p, width = 14, height = 9.8)

ggsave("f:/GDrive/16_pharma_reform_proposal/docs/fig_pricegaps.png",
       p, width = 14, height = 9.8, dpi = 150, bg = "white")

cat("Done.\n")
