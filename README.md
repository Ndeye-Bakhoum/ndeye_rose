
# DOSSIER SVM et Réseaux de Neurones Artificiels (ANN)

## Ndèye BAKHOUM Master2 ECAP 

Notre objectif pour cette étude sera à partir d'un jeu de donnée, prédire une variable cible en utilisant des méthodes de Machine Learning à savoir les SVM (Support Vector Machine) et les réseaux de neurones et après nous essayerons de déterminer les variables importantes.


### Description des données 

Nous avons choisi un ensemble de variables pour mener notre étude. Notre base de donnée est composée de 6 variables à savoir :

##### - Price:         Le prix de vente des maison
##### - SquareFeet :   La surface de la maison                  
##### - Bedrooms :     Le nombre de chambres              
##### - Bathrooms :    Le nombre de salle de bains
##### - YearBuilt :    L'année de construction de la maison             
##### - Neighborhood : Le quartier où est situé la maison

Notre variable cible correspond au prix de vente du biens immobiliers 'Price'. Avant de passer à la modélisation, nous allons effectuer un prétraitement de nos données (valeurs manquantes, outliers).


# I _ Analyse exploiratoire des données

Après l'importation de notre jeu de données, nous avons vérifié si toutes nos variables étaient aux formats. De ce fait nous avons transformé la variable 'Neighborhood' en variable catégorielle car disposant de 3 modalités (Rural, Suburb, Urban). La variable 'YearBuilt' devant être transformé en 'datetime', nous avons alors décidé de créer une nouvelle variable appelé 'Age' correspondant à la durée de la construction afin d'éviter des erreurs au niveau de la modélisation. Une fois la variable 'Age' crée nous avons décidé de supprimer la variable 'YearBuilt'.
#### - Valeurs manquantes
Certaines méthodes de Machine Learning sont très sensible aux valeurs manquantes. Ainsi il serait plus approprié de les détecter et les supprimer ou les imputer. Après vérification, nous constatons que notre jeu de donnée ne contient aucune valeur manquante.
#### - Outliers
Les valeurs aberrantes sont des points qui ne suivent pas la distribution caractéristique du reste des données. Pour les détecter nous allons créer le boxplot des variables afin de visualiser les points extrêmes.

![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/9047bbce-d977-45c3-bd52-7597d0b7eab7)

Le graphique ci-dessus représente les boxplots des différentes variables, nous avons ainsi constaté que seul la variable 'Price' possédait des valeurs extrêmes donc éviter des erreurs au niveau de nos estimations. De ce fait nous allons supprimer ces outliers en utilisant la méthode basée sur l'écart interquartile (IQR), nous passons alors d'une base de 50000 à 49941 observations soit 59 outliers supprimés. Une fois notre base de données nettoyer nous passer à l'analyse statistique des données.

# II_ Analyse statistique des données

  ##  1_ Statistiques descriptives des variables 
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/1248f292-1978-453a-b270-644b1c82866d)

Le tableau ci-dessus représente les statistiques descriptives de nos différentes variables quantitatives. Nous pouvons constater que la surface des maisons vendus varie entre 1000 et 2999 en pieds-carrées et que 50% de ces maisons ont une surface dépassant les 2000 pieds-carrés. Ces maisons ont un maximum de 5 chambres et 3 salles de bains et on note que ces maisons dotées  en moyenne de 2 chambres et une salle de bains. La maison la plus ancienne a été construit il y'a 74 ans et la plus récente en 2021 c'est à dire il y'a 3 ans. 
Le prix de vente maximum des maisons est estimé à 443335.494338 USD et le prix minimum est quant à lui fixé à 6124.032174 USD. On constate que les maisons sont vendues en moyenne à 224822.916361 USD.

  ##  2_ Histogramme sur la variable à expliquer 'Price' 
  ![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/5cfc5836-7fa0-4554-a8af-996673b53d7c)

Ce graphique représente l'histogramme du prix de vente des maisons. Nous constatons que le nombre de maisons vendus à moins de 100000 USD est très faible tout comme le nombre de maisons vendus à plus de 370000 USD. Cependant on retrouvera beaucoup de maisons qui sont vendus entre 100000 et 300000 USD.

 ##  3_ Représentation graphique des modalités de la variable 'Neighborhood'
Le graphique ci-dessous représente les différentes modalités de la variable 'Neighborhood'. Nous constatons que ces modalités sont réparties plus ou moins équitablement. On trouve que 33.2% des maisons sont situé en zone 'Urbain' contre 33.4% qui se situe en zone 'Rural' et pour ce qui concerne la banlieu 'Suburb' on n'y retrouve 33.4% des maisons vendus.

![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/4a494c7c-c537-49f2-8b2e-758120748701)

##  4_ Etude de la corrélation entre les variables
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/be7edba6-542b-45d4-9389-eed899addb38)

L'étude de la corrélation entre nos variables est très importante car il permet de détecter les liens existant ente nos variables. Nous constatons une relation linéaire positive et importante entre le prix de vente et la surface de la maison. Autrement dit plus la surface est élevée et plus le prix de vente est élevé. On note également une très légère corrélation entre le nombre de chambre et le prix de vente. A part ces variables, on note une des corrélations très faibles. Donc pas de risque de multicolinarité.  

##  5_ Etude de la relation entre les variables 'Price', 'Neighborhood' et 'SquareFeet'
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/f337577d-db3a-4061-8e89-26d0a7efba8b)

Nous constatons que la variable 'Neighborhood a un lien particulier entre les variables 'Price' et 'SquareFeet'. A savoir que le prix de vente des maisons peut dépendre de la zone où elle est située. Mais également la superficie de la maison peut varier en fonction des zones (Rural, Urbain, Banlieue).

# III_ Echantillonnage des données
Avant de commencer à modéliser nos données, nous avons d'abord séparé notre variable cible 'Price' de nos variables explicatives. Ensuite nous avons encodé la variable 'Neighborhood' afin d'éviter des erreurs au moment de la normalisation des variables. On sépare nos données en deux ensembles avec un taux d'échantillonnage de 20% :
- train: ensemble d'entrainement du modèle (80% des données)
- test: ensemble d'évaluation du modèle (20% des données)

# IV_ Modèles Machine Learning
##  1_ Modèle SVM(Support Vector Machine)
Une machine à vecteurs de support (SVM) est une classe d'algorithmes d'apprentissage automatique utilisée pour la classification et la régression. Les SVM peuvent être linéaires ou non linéaires en fonction du type de frontière de décision qu'ils construisent. Dans notre cas nous l'utiliserons pour faire une régression étant donné que notre objectif est de prédire le prix de vente. Nous déciderons d'estimer des modèles SVR non linéaire car jugeant que nos données ne sont pas linéarement séparable.
Ainsi nous avons estimé différents modèles SVR en fesant varier le kernel et le paramètre de régularisation C.

### - C=100
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/70933251-e3ca-472e-8801-58d8fe83b41c)

Pour un paramètre de régularisation (C) fixé à 100, nous avons estimé 3 modèles en fessant varier le kernel (linear, rbf, polynomiale). Pour evaluer la performances de ces modèles, nous nous sommes basés sur des métriques tels-que l'erreur quadratique moyenne (MSE), l'erreur absolu moyenne (MAE) et le coefficient de détermination R². Le meilleur modèle d'entre ces 3 est celui qui enregistre les erreurs les plus faible et le R² le plus élevé. De ce fait le meilleur modèle est le modèle0 qui correspond au SVR(kernel='linear', C=100).

### - C=10
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/7b863645-6c4b-4c83-9a2a-a2f934e08160)

Dans le but de trouver des modèles plus performants que ceux obtenus précédement, nous avons réestimé les 3 modèles mais cette fois ci en fessant passer le paramétre de régularisation de 100 à 10. Nous constatons que les modèles enregistrent des erreurs de prévisions plus élevées que ceux estimés ci-dessus. Avec C=10, le meilleur modèle est obtenu avec le modèle 0 SVR(kernel='linear', C=10) où on note les erreurs les plus faibles.

### - C=1
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/482888d5-a780-44a9-bafb-b60c3721587f)

Avec un paramètre de régularisation (C=1), nous avons estimés également trois modèles en fessant varier le kernel. Nous constatons que les résultats obtenus par rapport au 6 modèles estimés ci-dessus sont les faibles. Nous constatons ainsi plus le paramètre C diminue et plus les modèles enregistrent d'erreurs de prévisions. Dans tous les cas les meilleurs modèles sont obtenus avec le kernel(linear).
Des 9 modèles estimés, le meilleur est le  SVR(kernel='linear', C=100,  gamma="auto").
- NB!!! Nous avons utilisé le GridSearchCV afin de tester différents jeux de paramètres mais le code à tourner des jours sans résultats

##  2_ Modèle Réseaux de Neurones Artificiel (ANN)
Les ANN (Artificial Neural Network) sont des modèles de machine learning qui sont composé de plusieurs unités appelées neurones, organisées en couches. Nous avons:
- Couche d'entrée (Input Layer)
- Couches cachées (Hidden Layer)
- Couche de sortie (Output Layer)

#### - modèle1 : n_neurones = 1000, Hidden_layer = 2, activation = 'relu'
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/dde91916-ccf4-4026-9f8c-1f58b3953d51)
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/f375c119-e5f6-4854-8851-345b539ad43c)


Nous avons construit un modèle ANN en fixant un nombre de neurones à 1000 sur deux couches cachées, la fonction d'activation utilisée sur ces couches est le 'relu'. La couche de sortie est fixée à 1 neurone. Le modèle est compilé en utilisant un optimiseur de type 'adam'. On constate que le modèle fournit plus de 1000000 paramètres entrainables. Nous avons choisi 5 itérations sur l'ensemble de nos données pour l'apprentissage de notre modèle. La fonction de perte (loss) mesurant la différence entre les prédictions du modèle et les valeurs réelles est représentée par le MSE (Mean Squared Error), elle diminue au fil des itérations.  

#### - modèle2 : n_neurones = 500, Hidden_layer = 2, activation = 'relu'
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/0d50bb1b-c44b-4993-83c3-85b6d6fc6d72)
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/1546c146-a724-46bf-bcb9-5b168f900a46)

En gardant le même nombre de couche cachées et en diminuant le nombre de neurones jusqu'à 500, nous construit un nouveau modèle. Le nombre de paramètres à entrainer est fixé à 254001. Les erreurs diminue au fur et à mesure des itérations, à travers les résultats obtenus on peut dire que ce modèle est plus performant que le premier.

#### - Optimisation avec GridSearchCV
Afin de déterminer les paramètres optimales pouvant aboutir à un modèle plus performant, nous avons décidé de construire un modèle avec le GridSearchCV. Comme paramètres optimales nous recherchons le nombre de neurones, le nombre de couches cachées et la fonction d'activation. Ainsi le gridsearch réalise une validation croisée par 2fold se déclinant par des itérations jusqu'à l'obtention des meilleurs paramètres. Le modèle avec GridSearchCV nous donne ces paramètres:
- n_neurones = 200
- hidden_layer = 2
- activation = 'relu'
Nous avons ensuite tuner le modèle en utilisant ces paramètres :

#### - modèle3 : n_neurones = 200, Hidden_layer = 2, activation = 'relu'
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/667c4deb-e5b3-47d9-84d5-6d9965a4b564)
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/e96c1c49-a066-4048-94a4-733dfb06cd32)

Tout comme les autres modèles, on note que les erreurs de prévisions diminuent au fil des itérations. On constate également par rapport au deux modèles précédents que celui-ci est le plus performant (MSE et MAE plus petit). Cependant par rapport à notre meilleur modèle obtenu avec la méthode SVM, ce modèle est beaucoup moins performant.

# V_ Interprétation du modèle retenu : SVR(kernel='linear', C=100)
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/e07241ad-8cc3-46ad-8e46-79e12426642d)

Parmi les différents modèles estimés, nous avons décidé de retenir le modèle SVR dont le noyau est linéaire et le paramètre de régularisation est fixé à 100. Les erreurs de prévisions de ce modèle sont les faibles et un coefficient de détermination plus élevé. Ce dernier est égal à 0.566733 autrement 56.6733 des fluctuations du prix de ventes des maisons sont expliquées par les variables explicatives. On note que les variables 'SquareFeet', 'Bedrooms' et 'Bathrooms' ont des coéfficients positifs à savoir si ces variables augmentent d'une unité, le prix de vente va augmenter aussi. Le coefficient de l’âge se révèle négative, on peut dire plus une maison sera ancienne et moins le prix sera élevé.

#  VI_ Variables importantes
![image](https://github.com/Ndeye-Bakhoum/ndeye_rose/assets/154429723/abbd027d-907f-4a7e-b7df-063cbf9c1392)

Pour déterminer l'importance des variables, nous avons décidé d'estimer un modèle de RandomForest afin de savoir les variables qui peuvent influencer le prix de vente des maisons. Nous pouvons constater que sur nos 5 variables, la superficie (SquareFeet) est largement plus importante pour évaluer le prix de vente de la maison. Autrement dit plus la surface sera élevée et plus la maison aura un prix élevé. Comme autre variable importante nous avons le quartier (Neighborhood) qui peut aussi influencer le prix de vente. En effet le fait qu'une maison se trouve en zone urbaine peut devenir plus chère qu'une maison se trouvant en banlieue. On note aussi que le fait qu'une maison ait un nombre de chambre plus élevé aura un prix plus conséquent.




