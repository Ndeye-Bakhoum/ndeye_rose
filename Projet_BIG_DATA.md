# Projet Big Data : Analyse Prédictive du Diabète

![R](https://img.shields.io/badge/Language-R-blue.svg)
![Spark](https://img.shields.io/badge/Framework-Sparklyr-orange.svg)
![H2O](https://img.shields.io/badge/ML-H2O.ai-red.svg)


## Présentation du Projet
Ce projet propose une étude approfondie de la base de données "Diabetes" visant à identifier les facteurs déterminants de la maladie. L'objectif est de comparer les performances de modèles de Machine Learning entraînés sur des environnements **Big Data** (Spark) et des solutions de **ML automatisé** (H2O).

---
## Présentation des variables

##### - Pregnancies : Le nombre de grosseses
##### - Glucose :
##### - BloodPressure :
##### - SkinThickness :
##### - Insulin :
##### - BMI :
##### - DiabetesPedigreeFunction :
##### - Age : 
##### - Outcome : 0 = Absence de diabète, 1 = Présence de diabète
---

##  Pipeline Data Science

### 1. Exploration & Nettoyage (Data Cleaning)
*   **Analyse des types** : Étude de 768 observations et 9 variables (8 quantitatives, 1 binaire).
*   **Traitement des valeurs aberrantes** : Identification des valeurs "0" impossibles pour le Glucose, le BMI et l'Insuline.
*   **Imputation robuste** : Remplacement des valeurs manquantes et des outliers par la **médiane** pour stabiliser la distribution.

### 2. Visualisation (DataViz)
Utilisation de `ggplot2` pour mettre en évidence les relations clés :
*   **Courbes de densité** : Distinction claire du taux de glucose entre patients sains et diabétiques[cite: 1].
<img width="655" height="404" alt="image" src="https://github.com/user-attachments/assets/63c6d30c-1832-4586-9e35-fa3090a41b02" />

*   **Boxplots** : Mise en évidence d'un Indice de Masse Corporelle (BMI) plus élevé chez les patients à risques[cite: 1].
*   **Nuages de points** : Analyse de la relation croissante entre l'insuline et le glucose selon le statut diabétique[cite: 1].

---

##  Modélisation & Machine Learning

###  Sparklyr (Environnement Spark)
*   **Modèle** : Régression Logistique.
*   **Découpage** : 70% Apprentissage / 30% Test.
*   **Résultat** : Une AUC de **0.8082**, prouvant une excellente capacité de classification.

###  H2O Framework
Comparaison de trois algorithmes avec validation croisée (`nfolds = 5`) :
*   **Generalized Linear Model (GLM)**.
*   **Random Forest (DRF)** : 100 arbres, profondeur 20.
*   **Gradient Boosting Machine (GBM)**.

---

## Résultats & Comparaison Finale

L'évaluation a été réalisée sur l'échantillon Test à l'aide de la métrique **AUC** (Area Under Curve) :

| Modèle | Librairie | Score AUC |
| :--- | :--- | :--- |
| **Random Forest** | **H2O** | **0.8278** |
| **Régression Logistique** | **H2O** | **0.8196** |
| **Régression Logistique** | **Sparklyr** | **0.8082** |
| **Gradient Boosted Trees** | **H2O** | **0.8032** |

**Conclusion** : Le modèle **Random Forest** d'H2O offre la meilleure précision prédictive. Les variables les plus influentes sont la **concentration en glucose**, l'**IMC (BMI)** et l'**âge**.

---

