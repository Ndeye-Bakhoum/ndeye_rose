
# DOSSIER SVM et Réseaux de Neurones 

## Ndèye BAKHOUM Master2 ECAP 

Notre objectif pour cette étude sera à partir d'un jeu de donnée, prédire une variable cible en utilisant des méthode de Machine Learning à savoir les SVM(Support Vector Machine) et les reseaux de neurones et aprés nous essayerons de déterminer les variables importantes.


### Description des données 

Nous avons choisi un ensemble de variables pour mener notre étude. Notre base de donnée est composée de 6 variables à savoir:

#### - Price:         Le prix de vente des maison
#### - SquareFeet :   La surface de la maison                  
#### - Bedrooms :     Le nombre de chambres              
#### - Bathrooms :    Le nombre de salle de bains
#### - YearBuilt :    L'année de construction de la maison             
#### - Neighborhood : Le quartier où est situé la maison

Notre variable cible correspond au prix de vente du biens immobiliers 'Price'. Avant de passer à la modélisation, nous allons effectué un prétraitement de nos données (valeurs manquantes, outliers).


# I _ Analyse exploiratoire des données

Aprés l'importation de notre jeu de données, nous avons vérifier si toutes nos variables étaient aux formats. De ce fait nous avons transformé la variable 'Neighborhood' en variable catégorielle car disposant de 3 modalités (Rural, Unurban, Urban). La variable 'YearBuilt' devant être transformé en 'datetime', nous avons alors décidé de creer une nouvelle variable appelé 'Age' correspondant à la durée de la construction afin d'eviter des erreurs au niveau de la modélisation. Une fois la variable 'Age' crée nous avons décider de supprimer la variable 'YearBuilt'.
#### - Valeurs manquantes
Certaines méthodes de Machine Learning sont trés sensible aux valeurs manquantes. Ainsi il serait plus appoprié de les detecter et les supprimer ou les imputer. Aprés vérification, nous constatons que notre jeu de donnée ne contient aucune valeur manquante.
#### - Outliers
Les valeurs abbérantes sont des points qui ne suivent pas la distribution caractéristique du reste des données. Pour les détecter nous allons créer le boxplot des variables afin de visualiser les points extremes.

![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/a3873571-d88e-4cf4-9fab-d673aecb69da)

Le graphique ci-dessus représente les boxplots des différentes variables, nous avons ainsi constaté que seul la variable 'Price' possédait des valeurs extremes donc éviter des erreurs au niveau de nos estimations. De ce fait nous allons supprimer ces outliers en utilisant la méthode basée sur l'écart interquartile (IQR), nous passons alors d'une base de 50000 à 49941 observations soit 59 outliers supprimés. Une fois notre base de donnée néttoyer nous passer à l'analyse statistique des données.

# II_ Analyse statistique des données

  ##  1_ Statistiques descriptives des variables 
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/1248f292-1978-453a-b270-644b1c82866d)

Le tableau ci-dessus représente les statistiques descriptives de nos différentes variables quantitatives. Nous pouvons constaté que la surface des maisons vendus varie entre 1000 et 2999 en pieds-carrées et que 50% de ces maisons ont une surface dépasssant les 2000 pieds-carrés. Ces maisons ont un maximum de 5 chambres et 3 salles de bains et on note que ces maisons dotées  en moyenne de 2 chambres et une salle de bains. La maison la plus ancienne a été construit il y'a 74 ans et la plus récente en 2021 c'est à dire il y'a 3 ans. 
Le prix de vente maximun des maisons est estimé à 443335.494338 USD et le prix minimun est quant à lui fixé à 6124.032174 USD. On constate que les maisons sont vendus en moyenne à 224822.916361 USD.

  ##  2_ Histogramme sur la variable à expliquer 'Price' 
  ![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/21c04d24-c4c9-4914-9d7a-dd0edb382507)
 
Ce graphique représente l'histogramme  du prix de vente des maisons. Nous constatons que le nombre de maisons vendus à moins de 100000 USD est trés faible tout comme le nombre de maisons vendus à plus de 370000 USD. Par contre on retrouvera beaucoup de maisons qui sont vendus entre 100000 et 300000 USD.

 ##  3_ Représentation grahique des modalités de la variable 'Neighborhood'
Le graphique ci-dessous représente les différentes modalités de la variable 'Neighborhood'. Nous constatons que ces modalités sont répartis plus ou moins équitablement. On trouve que 33.2% des maisons sont situé en zone 'Urbain' contre 33.4% qui se situe en zone 'Rural' et pour ce qui concerne la banlieu 'Suburb' on n'y retrouve 33.4% des maisons vendus.

![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/630262cc-8d2a-4a45-81a2-bda63676010e)












