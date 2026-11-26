
library(corrplot)
library(Compind)

# BASELINE CORRELATIONS PER DIMENSION

# FIRST DIMENSION
dim1 <- as.data.frame(INDICATORI_PRIMA_DIMENSIONE_)
rownames(dim1) <- dim1[, 1]
dim1 <- dim1[, -1]

cor_dim1 <- round(cor(dim1, method = "pearson", use = "pairwise.complete.obs"), 2)
corrplot(
  cor_dim1,
  method = "number",
  type = "lower",
  diag = FALSE,
  tl.col = "black",
  col = "darkred",
  tl.srt = 45
)

# SECOND DIMENSION
dim2 <- as.data.frame(INDICATORI_SECONDA_DIMENSIONE_)
rownames(dim2) <- dim2[, 1]
dim2 <- dim2[, -1]
colnames(dim2) <- c(
  "housing_unavailability",
  "public_housing",
  "supply_type",
  "youth_incidence"
)

cor_dim2 <- round(cor(dim2, method = "pearson", use = "pairwise.complete.obs"), 2)
corrplot(
  cor_dim2,
  method = "number",
  type = "lower",
  diag = FALSE,
  tl.col = "black",
  col = "darkred",
  tl.srt = 45,
  mar = c(0, 0, 4, 0),
  tl.offset = 1
)

# THIRD DIMENSION
dim3 <- as.data.frame(INDICATORI_TERZA_DIMENSIONE_)
rownames(dim3) <- dim3[, 1]
dim3 <- dim3[, -1]
colnames(dim3) <- c("commercial_gentrification", "care_services", "decorum")

cor_dim3 <- round(cor(dim3, method = "pearson", use = "pairwise.complete.obs"), 2)
corrplot(
  cor_dim3,
  method = "number",
  type = "lower",
  diag = FALSE,
  tl.col = "black",
  col = "darkred",
  tl.srt = 45
)

# MIN-MAX STANDARDIZATION 

stand_dim1 <- normalise_ci(dim1, indic_col = 1:4, polarity = c("POS", "POS", "POS", "POS"), method = 2)
mat_stand1 <- round(as.data.frame(stand_dim1$ci_norm), 3)
colnames(mat_stand1) <- c("territorial_density", "carrying_capacity", "accommodation_replacement", "professionalization")

stand_dim2 <- normalise_ci(dim2, indic_col = 1:4, polarity = c("POS", "NEG", "NEG", "NEG"), method = 2)
mat_stand2 <- round(as.data.frame(stand_dim2$ci_norm), 3)

stand_dim3 <- normalise_ci(dim3, indic_col = 1:3, polarity = c("NEG", "NEG", "NEG"), method = 2)
mat_stand3 <- round(as.data.frame(stand_dim3$ci_norm), 3)

#DIMENSION INDICES AND COMPOSITE INDICATOR

index_dim1 <- data.frame(index_dim1 = rowMeans(stand_dim1$ci_norm, na.rm = TRUE))
index_dim2 <- data.frame(index_dim2 = rowMeans(stand_dim2$ci_norm, na.rm = TRUE))
index_dim3 <- data.frame(index_dim3 = rowMeans(stand_dim3$ci_norm, na.rm = TRUE))

combined_dataset <- cbind(index_dim1, index_dim2, index_dim3)

geom_mean <- function(x, na.rm = TRUE) {
  if (any(x <= 0, na.rm = na.rm)) {
    return(0)
  }
  exp(mean(log(x), na.rm = na.rm))
}

composite_indicator <- data.frame(
  composite_indicator = apply(combined_dataset, 1, geom_mean)
)
rownames(composite_indicator) <- rownames(dim1)