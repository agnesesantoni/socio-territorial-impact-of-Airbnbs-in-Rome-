

# Airbnb Touristification in Rome: A Composite Index Across the 15 Municipi

> Building a multidimensional composite indicator in R to measure how strongly short-term rentals affect each district of Rome (2025).




## Problem Statement

Airbnb and other short-term rentals can reshape cities. They can:

- put pressure on the housing market and make it harder for residents to find homes
- replace local shops with businesses aimed at tourists
- push out groups that don't fit the "tourist city" image, such as young people and the homeless

Rome is a strong case study. It is one of the world's top tourist destinations, had about **37,650 active Airbnb listings** in September 2025, and recorded more than **22.9 million tourist stays** in 2025 (a Jubilee year).

**Research question:** How strongly does Airbnb-driven touristification affect each of Rome's 15 municipi, and how do the districts differ?

**Approach:** Touristification is a complex, multidimensional concept, so no single variable can measure it. This project turns it into a **composite index** built from three dimensions and 11 indicators.

## Project at a Glance

| | |
|---|---|
| **Unit of analysis** | 15 municipi of Rome |
| **Time reference** | 2025 (Airbnb data: Sept 2025; official statistics: Dec 2024) |
| **Dimensions** | 3 (territory, housing, exclusion of residents) |
| **Indicators** | 11 ratios built from 12+ raw variables |
| **Normalization** | Min-max (0 to 1) with polarity adjustment |
| **Aggregation** | Arithmetic mean within dimensions, geometric mean across dimensions |
| **Tools** | R (`Compind`, `corrplot`)|

### Pipeline

```
Raw data  ->  Indicators (ratios)  ->  Correlation check  ->  Min-max normalization
                                                                       |
Composite index  <-  Geometric mean  <-  Dimension indices  <-  Arithmetic mean
```

## Data

| Source | What it provides |
|---|---|
| [Inside Airbnb](https://insideairbnb.com/) (Sept 2025) | Listings, beds, entire homes vs. private rooms, multi-host listings |
| Rome Statistical Yearbook 2025 | Population, young adults, hotels, businesses, homeless residents (data at 31 Dec 2024) |
| ISTAT permanent census 2023 | Empty homes |
| Mapparoma (2018) | Public housing (most recent available) |

## Variables and Indicators

All variables are counted per municipio, which is the administrative division of the city.

**Raw variables**

| Source | Variable | Description |
|---|---|---|
| Inside Airbnb | Listings | Number of active listings |
| Inside Airbnb | Beds | Total guests the listings can host (`accommodates`, summed) |
| Inside Airbnb | Entire homes | Listings of type "entire home/apt" |
| Inside Airbnb | Private rooms | Listings of type "private room" |
| Inside Airbnb | Multi-host listings | Listings run by hosts with more than one listing in the city (proxy for professional operators) |
| Yearbook | Population | Residents |
| Yearbook | Young adults | Residents aged roughly 25-34 |
| Yearbook | Homeless residents | People registered at a fictitious address (rough proxy) |
| Yearbook | Hotels | Traditional hotels only (B&Bs and guesthouses excluded, as many also list on Airbnb) |
| Yearbook | Retail and wholesale businesses | ATECO 45-47, services used by residents |
| Yearbook | Accommodation and food businesses | ATECO 55-56, activities aimed at passing visitors |
| Yearbook | Health and care businesses | ATECO 86-88, clinics, care homes, nurseries |
| ISTAT | Empty homes | Homes not permanently occupied by residents |
| Mapparoma | Public housing | ATER and municipal homes |
| Municipal data | Surface area | Used for listing density |

**Indicators**

| Dimension | Indicator | Calculation | Polarity |
|---|---|---|---|
| 1. Territory | Territorial density | Listings / area | + |
| 1. Territory | Carrying capacity | Airbnb beds / population | + |
| 1. Territory | Accommodation substitution | Listings / hotels | + |
| 1. Territory | Professionalization | Multi-host listings / listings | + |
| 2. Housing | Housing unavailability | Empty homes / population | + |
| 2. Housing | Public housing | Public homes / listings | - |
| 2. Housing | Type of offer | Private rooms / entire homes | - |
| 2. Housing | Youth share | Young adults / population | - |
| 3. Exclusion | Commercial gentrification | Retail businesses / accommodation and food businesses | - |
| 3. Exclusion | Care services | Health and care businesses / population | - |
| 3. Exclusion | Decorum | Homeless residents / population | - |

*Polarity:* "+" means a higher value indicates more touristification impact; "-" means a higher value indicates less. Negative-polarity indicators are inverted during standardization.

## Methodology

The design follows Lazarsfeld's process of turning a complex concept into measurable indicators.

1. **Define the construct and its dimensions** (territory, housing, exclusion of residents).
2. **Build indicators** as density or coexistence ratios and assign each a polarity.
3. **Check correlations** (Pearson) within each dimension to guide the choice of measurement model. Correlations were mostly low, so a **formative model** was used: indicators capture different parts of the concept rather than being interchangeable.
4. **Standardize** with **min-max scaling**. This gives unitless values between 0 and 1 and keeps the relative distances between districts. It was preferred to rank normalization (flattens differences) and z-scores (negative values, harder to read).
5. **Aggregate within each dimension** with the **arithmetic mean** (compensatory).
6. **Aggregate across dimensions** with the **geometric mean** (non-compensatory).

### Diagnostics

| Dimension | Correlation finding | Decision |
|---|---|---|
| 1. Territory | Density and carrying capacity: r = 0.99. All other pairs are low (up to -0.49). | Both kept, since they measure different things (spatial concentration vs. pressure on residents). |
| 2. Housing | All correlations low to moderate (highest: 0.57 between public housing and youth share). | Formative model. |
| 3. Exclusion | Care services and decorum: r = 0.97. Commercial gentrification is negatively correlated with both (-0.77, -0.62). | Treated as formative, since internal coherence is not high enough for a reflective model. |

## Results

### Composite index (0 = low, 1 = high touristification)

| Rank | Municipio | Territory | Housing | Exclusion | **Composite** |
|---|---|---|---|---|---|
| 1 | VIII - Appia Antica | 0.339 | 0.662 | 0.833 | **0.572** |
| 2 | XII - Monteverde | 0.263 | 0.702 | 0.797 | **0.528** |
| 3 | I - Centro Storico | 0.591 | 0.627 | 0.333 | **0.498** |
| 4 | XIII - Aurelia | 0.210 | 0.710 | 0.823 | **0.497** |
| 5 | II - Parioli/Nomentano | 0.165 | 0.803 | 0.856 | **0.484** |
| 6 | V - Prenestino/Centocelle | 0.283 | 0.524 | 0.738 | **0.478** |
| 7 | X - Ostia/Acilia | 0.190 | 0.716 | 0.797 | **0.477** |
| 8 | VII - San Giovanni/Cinecitta | 0.222 | 0.497 | 0.780 | **0.441** |
| 9 | XI - Arvalia/Portuense | 0.187 | 0.573 | 0.724 | **0.426** |
| 10 | IX - EUR | 0.160 | 0.490 | 0.769 | **0.393** |
| 11 | XV - Cassia/Flaminia | 0.109 | 0.644 | 0.789 | **0.381** |
| 12 | XIV - Monte Mario | 0.114 | 0.616 | 0.768 | **0.377** |
| 13 | III - Monte Sacro | 0.102 | 0.593 | 0.776 | **0.361** |
| 14 | VI - Roma delle Torri | 0.266 | 0.189 | 0.586 | **0.309** |
| 15 | IV - Tiburtina | 0.113 | 0.252 | 0.745 | **0.277** |

### Key findings

1. **This is not only a city centre problem.** The most affected district is semi-central Appia Antica (VIII), followed by Monteverde (XII). The historic centre ranks third.
2. **The centre is asymmetric.** Centro Storico (I) has by far the highest territorial impact (0.591) but the lowest exclusion score (0.333), which pulls its composite down. 
3. **Parioli/Nomentano (II)** combines the highest housing (0.803) and exclusion (0.856) scores with low impact on the territory.
4. **Semi-central and eastern districts** (V, VII, VIII, XII) show Airbnb replacing hotels, with a high share of professional hosts. These areas are in transition and the phenomena is professionalising itself.
5. **The outskirts** (IV, VI) score lowest, partly because of more public housing and less tourism. This does not mean they are doing well, as they still show gaps in services.
6. **Housing and exclusion scores are high almost everywhere**, pointing to a city-wide problem of young people leaving neighbourhoods and a lack of care services for residents.


## Reproducing the Analysis

### Requirements

- R (4.x recommended)
- Packages: `corrplot`, `Compind`

```r
install.packages(c("corrplot", "Compind"))
```

### Input

The script expects three data frames of ready-made indicators, one per dimension, with municipi (administrative disctricts) as rows and the first column holding the municipio names. Building the ratios from the raw data is not included in the script, this was done on excel before uploading it to R.

### Core code

```r
library(corrplot)
library(Compind)

# 1. Correlation matrix (example: dimension 1)
cor_dim1 <- round(cor(INDICATORI_PRIMA_DIMENSIONE_, method = "pearson"), 2)
corrplot(cor_dim1, method = "number", type = "lower", diag = FALSE,
         tl.col = "black", col = "darkred")

# 2. Min-max normalization with polarity (example: dimension 2)
stand_dim2 <- normalise_ci(INDICATORI_SECONDA_DIMENSIONE_, indic_col = 1:4,
                           polarity = c("POS", "NEG", "NEG", "NEG"), method = 2)

# 3. Dimension index = arithmetic mean of normalized indicators
indice_dim2 <- apply(stand_dim2$ci_norm, 1, mean)

# 4. Composite index = geometric mean of the three dimension indices
media_geom <- function(x) exp(mean(log(x)))
indicatore_unico <- apply(datasetunico, 1, media_geom)
```

**Polarity settings used**

| Dimension | Polarity (column order) |
|---|---|
| 1. Territory | POS, POS, POS, POS |
| 2. Housing | POS, NEG, NEG, NEG |
| 3. Exclusion | NEG, NEG, NEG |




## Limitations

- **Spatial scale:** municipi are large and internally mixed, so averages hide local differences.
- **Proxies:** some indicators are rough approximations (homeless people registered at fictitious addresses; retail and food-service categories serve both tourists and residents).
- **Data age:** public housing data is from 2018, and the sources are not systematically updated.
- **Attribution:** it is hard to separate Airbnb effects from long-standing problems, such as the state of public housing.
- **Jubilee year:** the 2025 Jubilee may have inflated some measures, but it is not analysed separately.
- **Indicator overlap:** density and carrying capacity are almost perfectly correlated (r = 0.99), so territorial impact is effectively counted twice.

