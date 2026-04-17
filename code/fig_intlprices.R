library(data.table)
library(ggplot2)

# ---- Data from Table 2 ----
drugs <- data.table(
  drug = c(
    # IRA-negotiated drugs (Wouters et al. JAMA 2025)
    "Eliquis", "Xarelto", "Jardiance", "Januvia", "Entresto",
    "Enbrel", "Stelara", "Imbruvica", "Farxiga"
  ),
  # US list prices (WAC, 30-day supply)
  US      = c(521, 517, 573, 527, 628, 7106, 7860, 14934, 565),
  # Estimated net prices after rebates (SSR Health / Wouters et al.)
  US_net  = c(309, 261, 252, 196, 458, 3572, 7860, 11571, 194),
  Australia = c(57, 51, 33, 31, 139, 754, 1342, 2137, 34),
  Canada  = c(80, 71, 67, 76, 182, 1135, 1813, 2320, 65),
  France  = c(64, 59, 38, 26, 157, 646, 1220, 2472, 39),
  Germany = c(69, 86, 51, 36, 150, 974, 2504, 4944, 42),
  Switzerland = c(82, 86, 51, 44, 145, 1177, 1730, 5172, 49),
  UK      = c(69, 65, 47, 43, 118, 852, 1292, 4447, 47),
  # Medicare negotiated prices (IRA, effective 2026)
  US_neg  = c(231, 197, 197, 113, 295, 2355, 4695, 9319, 179)
)

# Melt to long format
id_vars <- c("drug")
measure_vars <- c("US", "US_net", "Australia", "Canada", "France", "Germany",
                   "Switzerland", "UK", "US_neg")
long <- melt(drugs, id.vars = id_vars, measure.vars = measure_vars,
             variable.name = "country", value.name = "price")
long <- long[!is.na(price)]

# Clean country labels
long[country == "US", country := "US (list)"]
long[country == "US_net", country := "US (est. net)"]
long[country == "US_neg", country := "US (negotiated)"]

# Order drugs by appearance in table
drug_order <- drugs$drug
long[, drug := factor(drug, levels = drug_order)]

# Order countries: US list, US est. net, US negotiated, then alphabetical
country_order <- c("US (list)", "US (est. net)", "US (negotiated)",
                   "Australia", "Canada", "France",
                   "Germany", "Switzerland", "UK")
long[, country := factor(country, levels = country_order)]

# Colors: dark red = list, orange = est. net, green = negotiated, blue = others
cols <- c(
  "US (list)"       = "#B22222",
  "US (est. net)"   = "#E06030",
  "US (negotiated)" = "#2E8B57",
  "Australia"       = "#C0C0C0",
  "Canada"          = "#C0C0C0",
  "France"          = "#C0C0C0",
  "Germany"         = "#C0C0C0",
  "Switzerland"     = "#C0C0C0",
  "UK"              = "#C0C0C0"
)

size1 <- 14

p <- ggplot(long, aes(x = country, y = price, fill = country)) +
  geom_col(width = 0.7) +
  facet_wrap(~ drug, scales = "free_y", ncol = 3) +
  scale_fill_manual(values = cols, guide = "none") +
  labs(x = NULL, y = "Price (USD, 30-day supply)") +
  theme_minimal(base_size = size1) +
  theme(
    axis.text.x = element_text(angle = 60, hjust = 1, size = size1),
    axis.text.y = element_text(size = size1),
    axis.title = element_text(size = size1),
    strip.text = element_text(face = "bold", size = size1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(0.8, "lines"),
    plot.margin = margin(5, 10, 5, 5)
  )

ggsave("f:/GDrive/16_pharma_reform_proposal/latex/fig_intlprices.pdf",
       p, width = 14, height = 12)

cat("Done.\n")
