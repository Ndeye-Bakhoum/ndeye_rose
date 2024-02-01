
# DOSSIER SVM et Réseaux de Neurones 

## Ndèye BAKHOUM Master2 ECAP 

Notre objectif pour cette étude sera à partir d'un jeu de donnée, prédire une variable cible en utilisant des méthode de Machine Learning à savoir les SVM(Support Vector Machine) et les reseaux de neurones et aprés nous essayerons de déterminer les variables importantes.


### Description des données 

Nous avons choisi un ensemble de variables pour mener notre étude. Notre base de donnée est composée de 6 variables à savoir:

- Price:         Le prix de vente des maison
- SquareFeet :   La surface de la maison                  
- Bedrooms :     Le nombre de chambres              
- Bathrooms :    Le nombre de salle de bains
- YearBuilt :    L'année de construction de la maison             
- Neighborhood : Le quartier où est situé la maison

Notre variable cible correspond au prix de vente du biens immobiliers 'Price'. Avant de passer à la modélisation, nous allons effectué un prétraitement de nos données (valeurs manquantes, outliers).


# I _ Analyse exploiratoire des données

Aprés l'importation de notre jeu de données, nous avons vérifier si toutes nos variables étaient aux formats. De ce fait nous avons transformé la variable 'Neighborhood' en variable catégorielle car disposant de 3 modalités (Rural, Unurban, Urban). La variable 'YearBuilt' devant être transformé en 'datetime', nous avons alors décidé de creer une nouvelle variable appelé 'Age' correspondant à la durée de la construction afin d'eviter des erreurs au niveau de la modélisation. Une fois la variable 'Age' crée nous avons décider de supprimer la variable 'YearBuilt'
#### Valeurs manquantes
Certaines méthodes de Machine Learning sont trés sensible aux valeurs manquantes. Ainsi il serait plus appoprié de les detecter et les supprimer ou les imputer. Aprés vérification, nous constatons que notre jeu de donnée ne contient aucune valeur manquante.
#### Outliers
Les valeurs abbérantes sont des points qui ne suivent pas la distribution caractéristique du reste des données. Pour les détecter nous allons créer le boxplot des variables afin de visualiser les points extremes.



Le graphique ci dessus représente les boxplots des différentes variables, nous avons ainsi constaté que seul la variable 'Price' possédait des valeurs extremes donc éviter des erreurs au niveau de nos estimations. De ce fait nous allons supprimer ces outliers en utilisant la méthode basée sur l'écart interquartile (IQR), nous passons alors d'une base de 50000 à 49941 observations soit 59 outliers supprimés. Une fois notre base de donnée néttoyernous passer à l'analyse statistique des données.

# II_ Analyse statistique des données

  #  1_ Statistiques descriptives des variables 

















