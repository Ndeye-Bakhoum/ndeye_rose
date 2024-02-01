
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

##  4_ Etude de la corrélation entre les variables
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/41242d05-e3dc-4a58-948d-86a20bdef437)

L'etude de la corrélation entre nos variables est trés importante car il permet de détecter les liens existant ente nos variables. Nous constatons une relation lineaire positive et importante entre le prix de vente et la surface de la maison. Autrement dit plus la surface est élevé et plus le prix de vente est élevé. On note également une trés légère corrélation entre le nombre de chambre et le prix de vente. A part ces variables, on note une des corrélations trés faibles. Donc pas de risque de multicolinarité.  

##  5_ Etude de la relation entre les variables 'Price', 'Neighborhood' et 'SquareFeet'
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/5a7dc4e4-647e-4797-8923-35c8f92f436b)

Nous constatons que la variable 'Neighborhood n'as pas de lien particulier entre les variables 'Price' et 'SquareFeet'. A savoir que le prix de vente des maisons ne dépend de la zone où elle est située, de meme ce n'est le fait qu'une maison soit situé en zone rural qu'elle aura une superficie plus importante.

# III_ Echantillonnage des données
Avant de commencer à modéliser nos données, nous avons d'abord séparé notre variable cible 'Price' de nos variables explicatives. Ensuite nous avons encodé la variable 'Neighborhood' afin d'eviter des erreurs au moment de la normalisation des variables. On sépare nos données en deux ensemble avec un taux d'echantillonnage de 20% :
- train: ensemble d'entrainement du modèle (80% des données)
- test: ensemble d'evaluation du modèle (20% des données)

# IV_ Modèles Machine Learning
##  1_ Modèle SVM(Support Vector Machine)
Une machine à vecteurs de support (SVM) est une classe d'algorithmes d'apprentissage automatique utilisée pour la classification et la régression. Les SVM peuvent être linéaires ou non linéaires en fonction du type de frontière de décision qu'ils construisent. Dans notre cas nous l'utiliserons pour faire une régression étant donnée que notre objectif est de prédire le prix de vente. Nous déciderons d'estimer des modèles SVR non lineaire car jugeant que nos données ne sont pas linéarement séparable.
Ainsi nous avons estimé différents modèles SVR en fesant varier le kernel et le paramétre de régularisation C

### - C=100
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/d9074420-76d0-4b7c-9558-033445e69d46)

Pour un paramètre de régularisation (C) fixé à 100, nous avons estimé 3 modèles en fesant varier le kernel (linear, rbf, polynomiale). Pour evaluer la performances de ces modèles, nous nous sommes basés sur des métriques tels-que l'erreur quadratique moyenne (MSE), l'erreur absolu moyenne (MAE) et le coefficient de détermination R². Le meilleur modèle d'entre ces 3 est celui qui enregistre les erreurs les plus faible et le R² le plus élevé. De ce fait le meilleur modèle est le modèle0 qui correspond au SVR(kernel='linear', C=100).

### - C=10
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/21b03b2d-5125-4c9c-b1be-3ea42a971237)

Dans le but de trouver des modèles plus perfomants que ceux obtenus précedement, nous avons rééstimer les 3 modèles mais cette fois ci en fesant passer le paramétre de régularisation de 100 à 10. Nous constatons que les modèles enregistrent des erreurs de prévisions plus élevées que ceux estimés ci dessus. Avec C=10, le meilleur modèle est obtenu avec le modele 0 SVR(kernel='linear', C=10) où on note les erreurs les plus faibles.

### - C=1
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/633e9b87-a362-43bb-a929-3382cdfde056)

Avec un paramètre de régularisation (C=1), nous avons estimés également trois modèles en fesant varier le kernel. Nous constatons que les résultats obtenus par rapport au 6 modèles estimés ci-dessus sont les faibles. Nous constatons ainsi plus le paramétre C diminue et plus les modèles enregistrent d'erreurs de prévisions. Dans tout les cas les meilleurs modèles sont obtenus avec le kernel(linear).
Des 9 modèles estimés, le meilleur est le  SVR(kernel='linear', C=100,  gamma="auto").
- NB!!! Nous avons utilisé le GridSearchCV afin de tester différents jeux de paramètres mais le code à touner des jours sans résultats

##  2_ Modèle Réseaux de Neurones Artificiel (ANN)
Les ANN (Artificial Neural Network) sont des modèles de machine learning qui sont composé de plusieurs unités appelées neurones, organisées en couches. Nous avons:
- Couche d'entrée (Input Layer)
- Couches cachées (Hidden Layer)
- Couche de sortie (Output Layer)

#### - modèle1 : 





