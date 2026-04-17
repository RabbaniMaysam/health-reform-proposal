# Health Reform Proposal

Working paper: *One Drug, Many Prices: A Proposal to Reform US Healthcare Pricing.*

## Companion site

Sources and derivations for Figure 1 (price gaps across payers) are published at:

**https://rabbanimaysam.github.io/health-reform-proposal/**

The site is built from the `docs/` folder in this repository.

## Repository layout

- `docs/` — static site served by GitHub Pages (HTML, CSS, figure PNG).
- `latex/` — LaTeX source for the paper.
- `code/` — R scripts that generate figures.
- `data/` — source data notes.

## Regenerating the figure

```
Rscript code/fig_pricegaps.R
```

This writes both `latex/fig_pricegaps.pdf` (for the paper) and `docs/fig_pricegaps.png` (for the site).
