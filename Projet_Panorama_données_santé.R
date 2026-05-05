#################### PANORAMA DES DONNEES DE SANTE #################################

##### Auteur : NDEYE BAKHOUM 

##### LIBRAIRIES ####

library(readxl)
library(tidyverse)
library(corrplot)
library(stats)
library(lmtest)
library(sf)
library(maps)

##### IMPORTATION DES DONNEES  ####

getwd()
setwd("C:/Users/HP/Documents")

Base <- read_excel("BAKHOUM_WILLIAMS_Base.xlsx", sheet = "Donnees")

str(Base)

# Nos variables sont au format numeriques donc pas besoins de transformation  

sum(is.na(Base))

# Notre base ne contient pas de valeurs manquantes


##### ANALYSE EXPLOIRATOIRE DES DONNEES ####

# les Statistiques descriptives 

summary(Base[, c(3:6)])


# Representation de la densite des medecins generaliste par departement
# On va d'abord charger la carte  des departements francais ensuite fussionner 
# ces donnees avec notre base


france_map <- st_as_sf(map("france", plot = FALSE, fill = TRUE))

carte_data <- france_map %>%
  left_join(Base, by=c("ID"="Nom_departement"))

ggplot(carte_data) +
  geom_sf(aes(fill = Densite_MG), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "magma", name = "Médecins pour\n100 000 habitants") +
  labs(
    title = "Densité de médecins généralistes par département en France"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "right"
  )


# On va regrouper la densité des medecins en 5 categories (tres faible à tres eleve)
# On utilise la methode quantile pour repartir nos departements. Puis on represente
# la densite en fonction de ces classes.


carte_data$classe_densite <- cut(
  carte_data$Densite_MG,
  breaks = quantile(carte_data$Densite_MG, probs = seq(0,1,0.2), na.rm=TRUE),
  include.lowest = TRUE
)

ggplot(carte_data) +
  geom_sf(aes(fill = classe_densite), color="white", size=0.1) +
  scale_fill_brewer(palette="YlOrRd", name="Densité de médecins") +
  labs(
    title="Densite de médecins généralistes par département en France"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, face="bold"),
    legend.position="right"
  )


# Representation des departements à faible densite (territoire en desert medical)


seuil <- quantile(carte_data$Densite_MG, 0.25, na.rm = TRUE)
carte_data$desert_medical <- ifelse(carte_data$Densite_MG <= seuil, "faiblement-doté", "Autres")

ggplot(carte_data) +
  geom_sf(aes(fill = desert_medical), color="white", size=0.1) +
  scale_fill_manual(values=c("red","lightgrey")) +
  labs(
    title="Départements à faible densités medicales",
    fill="Type de territoire"
  ) +
  theme_void()

# On utilise la fonction corrplot pour obtenir la matrice de correlation de nos
# de nos differentes variables

corrplot(cor(Base[, -c(1,2)], use = "complete.obs"), method = "number", type = "upper", tl.cex = 0.5)


##### MODELE DE REGRESSION LINEAIRE ####

# Nous utlisons la fonction lm pour estimer la densite de medecins des departements 
# francais. Le summary du modele nous donne tout ce qui coefficients, p-value
# statistique de Fisher, R2 et R2 ajuste

modele <- lm(Densite_MG ~  Niveau_vie_median + Densite_pop + Part_seniors,
             data = Base)
summary(modele)

