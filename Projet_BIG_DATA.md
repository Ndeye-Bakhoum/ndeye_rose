# Projet Big Data : Analyse Prédictive du Diabète

![R](https://img.shields.io/badge/Language-R-blue.svg)
![Spark](https://img.shields.io/badge/Framework-Sparklyr-orange.svg)
![H2O](https://img.shields.io/badge/ML-H2O.ai-red.svg)
![Status](https://img.shields.io/badge/Status-Completed-success.svg)

## Présentation du Projet
Ce projet propose une étude approfondie de la base de données "Diabetes" visant à identifier les facteurs déterminants de la maladie[cite: 1]. L'objectif est de comparer les performances de modèles de Machine Learning entraînés sur des environnements **Big Data** (Spark) et des solutions de **ML automatisé** (H2O)[cite: 1].

---

##  Pipeline Data Science

### 1. Exploration & Nettoyage (Data Cleaning)
*   **Analyse des types** : Étude de 768 observations et 9 variables (8 quantitatives, 1 binaire)[cite: 1].
*   **Traitement des valeurs aberrantes** : Identification des valeurs "0" impossibles pour le Glucose, le BMI et l'Insuline[cite: 1].
*   **Imputation robuste** : Remplacement des valeurs manquantes et des outliers par la **médiane** pour stabiliser la distribution[cite: 1].

### 2. Visualisation (DataViz)
Utilisation de `ggplot2` pour mettre en évidence les relations clés :
*   **Courbes de densité** : Distinction claire du taux de glucose entre patients sains et diabétiques[cite: 1].
*   **Boxplots** : Mise en évidence d'un Indice de Masse Corporelle (BMI) plus élevé chez les patients à risques[cite: 1].
*   **Nuages de points** : Analyse de la relation croissante entre l'insuline et le glucose selon le statut diabétique[cite: 1].

---

##  Modélisation & Machine Learning

###  Sparklyr (Environnement Spark)
*   **Modèle** : Régression Logistique[cite: 1].
*   **Découpage** : 70% Apprentissage / 30% Test[cite: 1].
*   **Résultat** : Une AUC de **0.8082**, prouvant une excellente capacité de classification[cite: 1].

###  H2O Framework
Comparaison de trois algorithmes avec validation croisée (`nfolds = 5`)[cite: 1] :
*   **Generalized Linear Model (GLM)**[cite: 1].
*   **Random Forest (DRF)** : 100 arbres, profondeur 20[cite: 1].
*   **Gradient Boosting Machine (GBM)**[cite: 1].

---

## Résultats & Comparaison Finale

L'évaluation a été réalisée sur l'échantillon Test à l'aide de la métrique **AUC** (Area Under Curve)[cite: 1] :

| Modèle | Librairie | Score AUC |
| :--- | :--- | :--- |
| 🏆 **Random Forest** | **H2O** | **0.8278**[cite: 1] |
| 🥈 **Régression Logistique** | **H2O** | **0.8196**[cite: 1] |
| 🥉 **Régression Logistique** | **Sparklyr** | **0.8082**[cite: 1] |
| 🐢 **Gradient Boosted Trees** | **H2O** | **0.8032**[cite: 1] |

**Conclusion** : Le modèle **Random Forest** d'H2O offre la meilleure précision prédictive[cite: 1]. Les variables les plus influentes sont la **concentration en glucose**, l'**IMC (BMI)** et l'**âge**[cite: 1].

---

## 📂 Structure du dépôt
*   `Projet_BIG_DATA.Rmd` : Script source contenant l'intégralité de l'analyse et du code R[cite: 1].
*   `diabetes.csv` : Jeu de données utilisé[cite: 1].
*   `README.md` : Documentation du projet.

---
**Auteur** : NDEYE BAKHOUM 
**Formation** : Master en Économie de la Santé
