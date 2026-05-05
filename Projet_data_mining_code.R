##############################################################################
# PROJET DATA MINIG
# SURVIE AU CANCER DANS LES PAYS DE L'OCDE
# SOURCE: OCDE — Qualité des soins de santé (CONCORD)
# VARIABLE CIBLE: Taux de survie nette à 5 ans (%) → 3 classes

# Ndeye BAKHOUM 
##############################################################################

# LIBRAIRIES

library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)
library(nnet)         

set.seed(42)

#################### IMPORTATION DES DONNEES ##################################

getwd()
setwd("C:/Users/HP/Downloads")

raw <- read.csv("BAKHOUM_WILLIAMS_Projet_data_mining_donnees.csv",
  stringsAsFactors = FALSE,
  check.names      = FALSE,
  encoding         = "UTF-8",
  fileEncoding     = "UTF-8"
)

donnees <- raw[-1, c(6, 10, 16, 23, 25)]
colnames(donnees) <- c("Pays", "Cancer", "Sexe", "Annee", "Survie")

donnees$Survie <- as.numeric(donnees$Survie)
donnees$Annee  <- as.integer(donnees$Annee)
donnees <- donnees[!is.na(donnees$Survie), ]

dim(donnees)
print(head(donnees, 5))


################# NETTOYAGE DES DONNEES ET RECODAGE ###########################


donnees$Cancer <- ifelse(grepl("poumon",   donnees$Cancer), "Poumon",
                  ifelse(grepl("colon",    donnees$Cancer), "Colon",
                  ifelse(grepl("rectum",   donnees$Cancer), "Rectum",
                  ifelse(grepl("estomac",  donnees$Cancer), "Estomac",
                  ifelse(grepl("sein",     donnees$Cancer), "Sein",
                  ifelse(grepl("col de",   donnees$Cancer), "Col_uterus",
                  ifelse(grepl("leuc|LAL", donnees$Cancer, ignore.case=TRUE),
                  "Leucemie_LAL", "Autre")))))))

donnees$Sexe <- ifelse(grepl("minin",  donnees$Sexe), "Femme",
                ifelse(grepl("culin",  donnees$Sexe), "Homme",
                ifelse(grepl("otal",   donnees$Sexe), "Total", "Autre")))

donnees <- donnees[donnees$Sexe %in% c("Femme", "Homme"), ]

donnees$Classe_survie <- ifelse(donnees$Survie < 40,  "Faible",
                         ifelse(donnees$Survie <= 70, "Moyen", "Eleve"))

donnees$Classe_survie <- factor(donnees$Classe_survie,
                                levels = c("Faible", "Moyen", "Eleve"))
donnees$Cancer <- as.factor(donnees$Cancer)
donnees$Sexe   <- as.factor(donnees$Sexe)
donnees$Annee  <- as.factor(donnees$Annee)
donnees$Pays   <- as.factor(donnees$Pays)

print(head(donnees, 8))


########### STATISTIQUES ET DISTRIBUTION DE LA VARIABLE CIBLE ################

# Statistiques descriptives

summary(donnees)

# Repartition de la variable cible

tbl <- table(donnees$Classe_survie)
print(tbl)
print(round(prop.table(tbl) * 100, 1))

# Justification des seuils de discretisation

# Objectif : montrer que les seuils 40% / 70% sont fondes sur
# la distribution reelle des donnees et que les 3 classes crees
# sont bien statistiquement distinctes.

cat("\n=== DISTRIBUTION DE LA VARIABLE SURVIE ===\n")
cat("Min      :", min(donnees$Survie),                   "%\n")
cat("Q1 (25%):", quantile(donnees$Survie, 0.25),         "%\n")
cat("Médiane  :", median(donnees$Survie),                 "%\n")
cat("Moyenne  :", round(mean(donnees$Survie), 1),         "%\n")
cat("Q3 (75%):", quantile(donnees$Survie, 0.75),         "%\n")
cat("Max      :", max(donnees$Survie),                   "%\n")


# Histogramme avec les seuils annotés

dev.new()
hist(donnees$Survie,
     breaks = 30,
     col    = "#B5D4F4",
     border = "white",
     main   = "Distribution de la survie nette à 5 ans — justification des seuils",
     xlab   = "Survie nette (%)",
     ylab   = "Fréquence")
abline(v = 40, col = "#E05252", lty = 2, lwd = 2)
abline(v = 70, col = "#6DBD6D", lty = 2, lwd = 2)
abline(v = median(donnees$Survie), col = "#E9A135", lty = 3, lwd = 2)
legend("topright", bty = "n",
       legend = c("Seuil Faible (40%)",
                  "Seuil Élevé (70%)",
                  paste0("Médiane (", median(donnees$Survie), "%)")),
       col = c("#E05252", "#6DBD6D", "#E9A135"),
       lty = c(2, 2, 3), lwd = 2)

# Test de Kruskal-Wallis : valider que les 3 classes sont bien distinctes

print(kruskal.test(Survie ~ Classe_survie, data = donnees))

# p < 0.05 confirme que les 3 classes sont significativement différentes


#################### EXPLORATION VISUELLE (EDA) ###############################


#  Repartition des classes

dev.new()
barplot(table(donnees$Classe_survie),
        main = "Répartition des classes de survie à 5 ans",
        col  = c("#E05252", "#E9A135", "#4E8CCA"),
        ylab = "Nombre d'observations",
        xlab = "Classe de survie")

#  Survie moyenne par cancer

dev.new()
moy_cancer <- sort(tapply(donnees$Survie, donnees$Cancer, mean))
par(mar = c(5, 10, 4, 2))
barplot(moy_cancer,
        horiz = TRUE, las = 1, col = "#4E8CCA",
        main  = "Survie nette moyenne à 5 ans par type de cancer (OCDE)",
        xlab  = "Survie moyenne (%)", xlim = c(0, 100))
abline(v = 40, lty = 2, col = "#E05252", lwd = 2)
abline(v = 70, lty = 2, col = "#6DBD6D", lwd = 2)
legend("bottomright", bty = "n",
       legend = c("Seuil Faible (40%)", "Seuil Élevé (70%)"),
       col    = c("#E05252", "#6DBD6D"), lty = 2, lwd = 2)
par(mar = c(5, 4, 4, 2))

#  Evolution temporelle

dev.new()
moy_annee <- tapply(donnees$Survie, donnees$Annee, mean)
plot(as.integer(names(moy_annee)), moy_annee,
     type = "b", pch = 19, col = "#4E8CCA", lwd = 2,
     main = "Évolution du taux de survie moyen à 5 ans",
     xlab = "Période", ylab = "Survie nette moyenne (%)",
     ylim = c(40, 65), xaxt = "n")
axis(1, at = c(2004, 2009, 2014))

# Figure 4 : Boxplots par cancer

dev.new()
par(mar = c(8, 5, 4, 2))
boxplot(Survie ~ Cancer, data = donnees,
        las  = 2, col = "#4E8CCA",
        main = "Distribution de la survie par type de cancer",
        ylab = "Survie nette à 5 ans (%)")
abline(h = 40, lty = 2, col = "#E05252", lwd = 2)
abline(h = 70, lty = 2, col = "#6DBD6D", lwd = 2)
par(mar = c(5, 4, 4, 2))

# Figure 5 : Top 10 / Bottom 10 pays

moy_pays <- sort(tapply(donnees$Survie, donnees$Pays, mean), decreasing = TRUE)
top10    <- head(moy_pays, 10)
bottom10 <- tail(moy_pays, 10)

dev.new(width = 12, height = 6)
par(mfrow = c(1, 2), mar = c(5, 7, 3, 1))
barplot(rev(top10),
        names.arg = rev(names(top10)),
        horiz = TRUE, las = 1, col = "#4E8CCA", xlim = c(0, 90),
        main = "Top 10 pays (survie élevée)",
        xlab = "Survie moy. (%)", cex.names = 0.8)
barplot(rev(bottom10),
        names.arg = rev(names(bottom10)),
        horiz = TRUE, las = 1, col = "#E05252", xlim = c(0, 90),
        main = "Bottom 10 pays (survie faible)",
        xlab = "Survie moy. (%)", cex.names = 0.8)
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))

# Tests statistiques

# TEST DE KRUSKAL-WALLIS : Survie ~ Cancer 
print(kruskal.test(Survie ~ Cancer, data = donnees))

# TEST DE KRUSKAL-WALLIS : Survie ~ Annee 
print(kruskal.test(Survie ~ Annee, data = donnees))

# TEST DE WILCOXON : Survie ~ Sexe 
print(wilcox.test(Survie ~ Sexe, data = donnees))


################# MODELISATION : ARBRE DE DECISION (CART) #####################

df_model <- donnees[, c("Cancer", "Annee", "Sexe", "Classe_survie")]

# Division train / test (70% / 30%)

idx   <- createDataPartition(df_model$Classe_survie, p = 0.70, list = FALSE)
train <- df_model[ idx, ]
test  <- df_model[-idx, ]

# Validation croisee 5 plis

ctrl <- trainControl(method = "cv", number = 5, savePredictions = "final")

# Entrainement CART

arbre <- train(
  Classe_survie ~ .,
  data      = train,
  method    = "rpart",
  tuneGrid  = data.frame(cp = seq(0.0001, 0.01, by = 0.0005)),
  trControl = ctrl
)
cat("Meilleur cp :", arbre$bestTune$cp, "\n")

# Visualisation de l'arbre

dev.off()
dev.new(width = 14, height = 8)
par(mar = c(1, 1, 2, 1))
rpart.plot(
  arbre$finalModel,
  type        = 4,
  extra       = 104,
  main        = "Arbre de décision — Classe de survie au cancer (OCDE)",
  box.palette = list("Reds", "Oranges", "Blues"),
  shadow.col  = "gray80",
  cex         = 0.75
)


############### MODELES CONCURRENTS POUR COMPARAISON #########################


# Modele 1 : Arbre CART (Preparation pour la comparaison) 

pred_cart <- predict(arbre, newdata = test)
mc        <- confusionMatrix(pred_cart, test$Classe_survie)

# Modele 2 : Random Forest

set.seed(42)
rf <- train(
  Classe_survie ~ .,
  data      = train,
  method    = "rf",
  tuneGrid  = data.frame(mtry = c(1, 2, 3)),
  trControl = ctrl
)
cat("Meilleur mtry :", rf$bestTune$mtry, "\n")

pred_rf <- predict(rf, newdata = test)
mc_rf   <- confusionMatrix(pred_rf, test$Classe_survie)

# Modele 3 : Regression Logistique Multinomiale 

set.seed(42)
rl <- train(
  Classe_survie ~ .,
  data      = train,
  method    = "multinom",
  trControl = ctrl,
  trace     = FALSE
)

pred_rl <- predict(rl, newdata = test)
mc_rl   <- confusionMatrix(pred_rl, test$Classe_survie)

# Tableau comparatif des 3 modeles 

comparaison <- data.frame(
  Modele    = c("Arbre de Décision (CART)",
                "Random Forest",
                "Régression Logistique Multinomiale"),
  Accuracy  = round(c(mc$overall["Accuracy"],
                      mc_rf$overall["Accuracy"],
                      mc_rl$overall["Accuracy"]), 4),
  Kappa     = round(c(mc$overall["Kappa"],
                      mc_rf$overall["Kappa"],
                      mc_rl$overall["Kappa"]), 4),
  F1_Faible = round(c(mc$byClass["Class: Faible", "F1"],
                      mc_rf$byClass["Class: Faible", "F1"],
                      mc_rl$byClass["Class: Faible", "F1"]), 4),
  F1_Moyen  = round(c(mc$byClass["Class: Moyen",  "F1"],
                      mc_rf$byClass["Class: Moyen",  "F1"],
                      mc_rl$byClass["Class: Moyen",  "F1"]), 4),
  F1_Eleve  = round(c(mc$byClass["Class: Eleve",  "F1"],
                      mc_rf$byClass["Class: Eleve",  "F1"],
                      mc_rl$byClass["Class: Eleve",  "F1"]), 4)
)
print(comparaison)
write.csv(comparaison, "comparaison_modeles_OCDE.csv", row.names = FALSE)

# Graphique comparatif

dev.new()
barplot(
  comparaison$Accuracy,
  names.arg = c("CART", "Random\nForest", "Rég. Log.\nMultinom."),
  col       = c("#378ADD", "#1D9E75", "#D85A30"),
  ylim      = c(0.80, 1.00),
  main      = "Comparaison des modèles — Accuracy sur le jeu de test",
  ylab      = "Accuracy",
  border    = "white"
)
abline(h = max(comparaison$Accuracy), lty = 2, col = "gray40")
text(x      = seq(0.7, by = 1.2, length.out = 3),
     y      = comparaison$Accuracy + 0.005,
     labels = paste0(round(comparaison$Accuracy * 100, 1), "%"),
     cex    = 0.9, font = 2)



##################### EVALUATION DES PERFORMANCES #############################


pred <- predict(arbre, newdata = test)
mc   <- confusionMatrix(pred, test$Classe_survie)

# MATRICE DE CONFUSION — CART
print(mc$table)

# METRIQUES GLOBALES 
cat("Précision (Accuracy) :", round(mc$overall["Accuracy"], 4), "\n")
cat("Kappa                :", round(mc$overall["Kappa"],    4), "\n")

# METRIQUES PAR CLASSE
print(round(mc$byClass[, c("Sensitivity", "Specificity", "F1")], 4))

# IMPORTANCE DES VARIABLES
imp <- varImp(arbre)$importance
imp$Variable <- rownames(imp)
imp <- imp[order(-imp$Overall), ]
print(imp)

par(mar = c(5, 8, 4, 2))
barplot(rev(imp$Overall),
        names.arg = rev(imp$Variable),
        horiz = TRUE, las = 1, col = "#4E8CCA",
        main = "Importance des variables — Arbre de décision",
        xlab = "Importance (%)")


################ VERIFICATION DU SURAPPRENTISSAGE #############################

# Comparer les performances sur le jeu d'entrainement vs de test.
# Un écart < 3 points indique l'absence de surapprentissage.

pred_train <- predict(arbre, newdata = train)
mc_train   <- confusionMatrix(pred_train, train$Classe_survie)

cat(sprintf("%-35s Accuracy   Kappa\n", "Modèle"))
cat(sprintf("%-35s %.4f     %.4f\n",
            "CART — jeu d'entraînement",
            mc_train$overall["Accuracy"],
            mc_train$overall["Kappa"]))
cat(sprintf("%-35s %.4f     %.4f\n",
            "CART — jeu de test",
            mc$overall["Accuracy"],
            mc$overall["Kappa"]))

gap <- mc_train$overall["Accuracy"] - mc$overall["Accuracy"]
cat(sprintf("\nÉcart train-test : %.2f points — %s\n",
            gap * 100,
            ifelse(gap < 0.03,
                   "pas de surapprentissage détecté",
                   "surapprentissage possible — envisager un élagage")))


###################### EXPORT FINAL #########################################


resultats <- data.frame(
  Modele    = "Arbre de Décision (CART)",
  Precision = round(mc$overall["Accuracy"], 4),
  Kappa     = round(mc$overall["Kappa"],    4),
  F1_Faible = round(mc$byClass["Class: Faible", "F1"], 4),
  F1_Moyen  = round(mc$byClass["Class: Moyen",  "F1"], 4),
  F1_Eleve  = round(mc$byClass["Class: Eleve",  "F1"], 4)
)
write.csv(resultats, "resultats_modele_OCDE.csv", row.names = FALSE)
print(resultats)



