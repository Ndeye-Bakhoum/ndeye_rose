# Projet Big Data : Analyse Prédictive du Diabète

![R](https://img.shields.io/badge/Language-R-blue.svg)
![Spark](https://img.shields.io/badge/Framework-Sparklyr-orange.svg)
![H2O](https://img.shields.io/badge/ML-H2O.ai-red.svg)


## Présentation du Projet
Ce projet propose une étude approfondie de la base de données "Diabetes" visant à identifier les facteurs déterminants de la maladie. L'objectif est de comparer les performances de modèles de Machine Learning entraînés sur des environnements **Big Data** (Spark) et des solutions de **ML automatisé** (H2O).

---
## Présentation des variables

*  **Pregnancies** : Le nombre de grosseses
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
*   **Courbes de densité** : Distinction claire du taux de glucose entre patients sains et diabétiques.
<img width="655" height="404" alt="image" src="https://github.com/user-attachments/assets/63c6d30c-1832-4586-9e35-fa3090a41b02" />

Nous avons représenté l'histogramme du Glucose selon le fait fait qu'il y ai ou pas diabète. Pour visualiser la distribution de la variable Glucose, nous tracons la courbe de densité. Avec un alpha = 0.4 on peut voir comment les deux courbes se chevauchent. En obervant nos deux courbes de densité, on constate que la distribution des personnes non diabètiques contient des valeurs de glucose plus faibles alors que celle des personnes diabètiques englobent les valeurs de glucose plus. En conclusion les personnes ayant le diabète ont en moyenne des taux de glucose significativement plus élevés.
*   **Boxplots** : Mise en évidence d'un Indice de Masse Corporelle (BMI) plus élevé chez les patients à risques.
<img width="655" height="404" alt="image" src="https://github.com/user-attachments/assets/02a429f0-6c6a-4392-9159-89a8329512b7" />

Les boxplots de l'indice masse corporelle selon le statut du diabète permet de comparer les médianes entre les deux groupes. On constate une médiane plus basse pour les personnes non diabètiques et des valeurs moins élevées contrairement à celle des personnes diabètiques qui présentent une médiane et des valeurs plus élevées. En conclusion on peut dire que les patientes atteintes de diabète ont un indice masse corporelle plus élevées que celles qui n'ont pas de diabète.
*   **Nuages de points** : Analyse de la relation croissante entre l'insuline et le glucose selon le statut diabétique.
<img width="655" height="404" alt="image" src="https://github.com/user-attachments/assets/c2a44084-7d96-4cfe-805e-b58f152a5bc5" />

Ce graphique ci-dessus permet de mettre en évidence la relation entre l'insulinémie sérique et la concentration de glucose en fonction du statut de diabète. Nous constaons une relation croissante entre les deux variables en d'autres termes une augmentation de la concentration de glucose entraine une hausse du l'insuline. On note ainsi que le groupe des personnes atteintes de diabète ont des niveaux de glucose et d'insuline plus élevés.

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

