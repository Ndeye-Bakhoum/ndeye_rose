#################### META-ANALYSE BAYESIENNE EN RESEAU ########################

##### NDEYE BAKHOUM 

##### LIBRAIRIES ####

library(readxl)
library(tidyverse)
library(meta)
library(R2WinBUGS)
library(coda)
library(forestplot)


getwd()
setwd("C:/Users/HP/Documents")

################# CONSTRUCTION DU RESEAU DE PREUVE ############################

# IMPORTATION DES DONNEES

df <- read_excel("MTC.xlsx", sheet = "tab1") 
df$Etude <- factor(df$Etudes, levels = rev(df$Etudes))


ggplot(df) +
  
  geom_vline(xintercept = 1:6, linetype = "dotted", color = "grey70") +
  geom_segment(aes(x = Treference, xend = Tetudie, y = Etude, yend = Etude), 
               arrow = arrow(length = unit(0.15, "cm"), ends = "both", type = "closed"),
               linewidth = 0.7, color = "black") +
  geom_point(aes(x = Treference, y = Etude), shape = 21, fill = "white", size = 3) +
  geom_point(aes(x = Tetudie, y = Etude), shape = 21, fill = "white", size = 3) +
  scale_x_continuous(
    breaks = 1:6, 
    labels = c("Traitement1\n(SoC)", "Traitement2\n(4LB)", "Traitement3\n(CH)", 
               "Traitement4\n(ACT)", "Traitement5\n(AD)", "Traitement6\n(Laser)"), 
    limits = c(0.5, 6.5)
  ) +
  
  labs(
    title = "Réseau de Preuve",
    x = "Traitements",
    y = NULL
  ) +
  theme_minimal() + 
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(size = 9, face = "italic"), 
    axis.text.x = element_text(size = 10, face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold")
  )

################# CONSTRUTION DU FOREST PLOT ################################

# IMPORTATION DES DONNEES

df <- read_excel("MTC.xlsx", sheet = "tab2")
str(df)
# Calcul de la méta-analyse
# event.e = événements groupe experimental, event.c = groupe controle
m_bin <- metabin(event.e = e_exp, n.e = n_exp,
                 event.c = e_ctrl, n.c = n_ctrl,
                 data = df,
                 studlab = Etudes,
                 sm = "OR",           
                 method = "Inverse",  
                 common = TRUE,       
                 random = TRUE,       
)

meta::forest(m_bin,
             leftcols = c("studlab"),
             rightcols = FALSE,
             col.square = "red",
             col.study = "purple",
             col.diamond = "black",
             # axe X et graduations logarithmiques 
             at = c(0.32, 1, 3.16, 10, 31.62, 100),
             log = TRUE,
             xlab = "Odds Ratio",
             print.I2 = FALSE,       
             print.tau2 = FALSE,     
             print.Q = FALSE,        
             print.pval.Q = FALSE,   
             print.tau = FALSE,      
             overall = TRUE,         
             overall.hetstat = FALSE, 
             common = FALSE,         
             random = TRUE,          
             text.random = "Effet Moyen Poolé" 
)

# Resume du modele
print(m_bin)

################# ESTIMATION DE MODELE BAYESIEN PAR MCMC ####################

# IMPORTATION DES DONNEES

df <- read_excel("MTC.xlsx", sheet = "tab3")  
df<-data.frame(df)
fix(df)

# CREATION DES VECTEURS ET FONCTIONS NECESSAIRE POUR LA SIMULATION MCMC

# Nombre d'essai temoins 

NPlc<-15

# Vecteur contenant l'indiçage des essais en fonction du traitement

t=c( 1, 2, 1, 2, 1, 2, 
     2, 3, 2, 3, 2, 3, 
     2, 4, 2, 4, 2, 4, 
     1, 5, 1, 5 ,1, 5,
     1, 6, 1, 6 ,1, 6)

# n : effectif des essai

n <- df$Effectifs

# r20 : effectif repondeur ACR20

r20 <- df$ACR_20

# NB : Nombre de bras

NB <- nrow(df) 

# NE : Nombre d'etude

NE <- NB/2

# s->Indice de l'etude

s<-NULL
j<-1
for (i in seq(1,NB-1,by=2)) {  s[i]<-j 
s[i+1]<-j
j<-j+1	} 

# b->Vecteur ligne egal e 1

b<-rep(1,NB)


# NT->Nombre de traitements differents

NT<-max(t)

#Recapitulatif de l'ensemble des donnees necessaires au modele

data20 <- list (NB=NB,NE=NE,NT=NT,NPlc=NPlc,s=s,b=b,t=t,n=n,r20=r20)

# Initialisation des chaines

mu<-rep(1,NB/2)

inits<- list(
  list(d=c(NA,(rep(1,NT-1)*0)),mu=mu*0),              #chaine numero 1
  list(d=c(NA,(rep(1,NT-1)*0.5)),mu=0.5*mu),          #chaine numero 2
  list(d=c(NA,(rep(1,NT-1)*(-0.5))),mu=-0.5*mu))     #chaine numero 3

# Indication des parametres que l'on souhaite analyser

parameters <- c("T","lor","or","d","best","bestc","rk")

##############################################################################
# ESTIMATION AVEC UN MODELE AVEC EFFETS FIXES
##############################################################################

mod1 <- bugs (data=data20, inits=inits, parameters=parameters, 
                 file.choose(), n.chains=3,n.iter=40000,n.burnin=500,n.thin=1,n.sims=500,debug=FALSE)
print(mod1,digits=3)
plot(mod1)
summary(mod1)

# Diagnostic de convergence

# Recuperation des fichiers coda

mod1.coda<-read.bugs(c(
  file.choose(),#fichier coda1.txt 
  file.choose(),#fichier coda2.txt
  file.choose())#fichier coda3.txt
)


# Trace plot avec le parametre T


par(mfrow = c(3, 2))
plot(mod1.coda[, grep("^T\\[", varnames(mod1.coda))], 
     trace = TRUE,      
     density = FALSE,    
     auto.layout = FALSE) 
par(mfrow = c(1, 1))

#Diagnostic de Gelman&Rubin


# Test de Gelman.diag

gelman.diag(mod1.coda[, grep("^T\\[", varnames(mod1.coda))])
gelman.plot(mod1.coda[, grep("^T\\[", varnames(mod1.coda))])

#Diagnostic de Raftery&Lewis

raftery.diag(mod1.coda)

# Resultats statistiques et graphiques

summary(mod1.coda)
print(mod1,digits=3)
plot(mod1)

#Affichage d'une partie des resultats 

print(mod1.coda[1,]) 

pdf("mod1_sim.pdf", width = 11, height = 8) 
plot(mod1)                                  
dev.off()


# Effet moyen du traitement par rapport au traitemment de reference

nom_traitements <- c("4LB", "CH", "ACT", "AD", "Laser") 
forestplot(labeltext = nom_traitements, 
           mean  = mod1$summary[22:26, "mean"], 
           lower = mod1$summary[22:26, "2.5%"], 
           upper = mod1$summary[22:26, "97.5%"],
           zero  = 1,            
           xlog  = TRUE,         
           clip  = c(0.1, 15),   
           xlab  = "Odds Ratio (OR)",
           col   = fpColors(box = "royalblue", line = "darkblue", zero = "black"),
           boxsize = 0.4)

forestplot(labeltext = nom_traitements, 
           mean  = mod1$summary[7:11, "mean"], 
           lower = mod1$summary[7:11, "2.5%"], 
           upper = mod1$summary[7:11, "97.5%"],
           zero  = 0,            
           xlog  = FALSE,         
           xlab  = "Log Odds Ratio (Log(OR))",
           col   = fpColors(box = "royalblue", line = "darkblue", zero = "black"),
           boxsize = 0.4)



#Comparaison des densites de la loi a posteriori des trois chaines d'un parametre 
densites.posteriori<-function(name){
  array<-mod1$sims.array[,,]
  plot(density(array[,1,name]),col=1,main="densites pour chaque chaine",sub=name)
  lines(density(array[,2,name]),col=2)
  lines(density(array[,3,name]),col=3)
}
par=mfrow(c(1,2))
densites.posteriori(1) #pour le parametre numero 1 (T[1]) pour les 3 chaines
densites.posteriori(6) #pour le parametre numero 6 (T[6]) pour les 3 chaines
par=mfrow(c(1,1))

# Matrice de classement des traitements


rk_sims <- mod1$sims.list$rk  # Récupère tous les rangs simulés
matrice_rangs <- apply(rk_sims, 2, function(x) table(factor(x, levels=1:6)))
prob_matrice <- t(matrice_rangs / nrow(rk_sims)) 
rownames(prob_matrice) <- c("SoC", "4LB", "CH", "ACT", "AD", "Laser")
colnames(prob_matrice) <- paste("Rang", 1:6)
tableau_final <- as.data.frame(round(prob_matrice, 3))
print(tableau_final)

# Calcul du score SUCRA

prob_cumulees <- t(apply(tableau_final, 1, cumsum))
k <- ncol(tableau_final)
somme_cumulee <- rowSums(prob_cumulees[, 1:(k-1)])
sucra_scores <- somme_cumulee / (k - 1)
print(sort(sucra_scores, decreasing = TRUE))


##############################################################################
# ESTIMATION AVEC UN MODELE AVEC EFFETS ALEATOIRE
##############################################################################

# Nombre d'essai temoins 

NPlc<-15

# Vecteur contenant l'indiçage des essais en fonction du traitement

t=c( 1, 2, 1, 2, 1, 2, 
     2, 3, 2, 3, 2, 3, 
     2, 4, 2, 4, 2, 4, 
     1, 5, 1, 5 ,1, 5,
     1, 6, 1, 6 ,1, 6)

# n : effectif des essai

n <- df$Effectifs

# r20 : effectif repondeur ACR20

r20 <- df$ACR_20

# NB : Nombre de bras

NB <- nrow(df) 

# NE : Nombre d'etude

NE <- NB/2

# s->Indice de l'etude

s<-NULL
j<-1
for (i in seq(1,NB-1,by=2)) {  s[i]<-j 
s[i+1]<-j
j<-j+1	} 

# b->Vecteur ligne egal e 1

b<-rep(1,NB)


# m->Vecteur indiquant pour chaque etude le traitement comparateur (1) et le traitement testé (2)
m<-NULL
m<-rep(1,NB)
for (i in seq(2,length(b),by=2)) { m[i]<-2 }


# NT->Nombre de traitements differents

NT<-max(t)

#Recapitulatif de l'ensemble des donnees necessaires au modele

data20 <- list (NB=NB,NE=NE,NT=NT,NPlc=NPlc,s=s,b=b,t=t,m=m,n=n,r20=r20)

# Initialisation des chaines

mu<-rep(1,NB/2)
delta<-rep(1,NB)

inits<- list(
  list(d=c(NA,(rep(1,NT-1)*0)),mu=mu*0,delta=delta*0,sd=1),           #chaine numero 1
  list(d=c(NA,(rep(1,NT-1)*0.5)),mu=0.5*mu,delta=0.5*delta,sd=0.5),   #chaine numero 2
  list(d=c(NA,(rep(1,NT-1)*(-0.5))),mu=-0.5*mu,delta=(-0.5)*delta,sd=2))#chaine numero 3

# Indication des parametres que l'on souhaite analyser

parameters <- c("T","lor","or","d","sd","best","bestc","rk")


mod2 <- bugs (data=data20, inits=inits, parameters=parameters, 
              file.choose(), n.chains=3,n.iter=40000,n.burnin=500,n.thin=1,n.sims=500,debug=FALSE)
print(mod2,digits=3)
plot(mod2)
summary(mod2)

# Diagnostic de convergence

# Recuperation des fichiers coda

mod2.coda<-read.bugs(c(
  file.choose(),#fichier coda1.txt 
  file.choose(),#fichier coda2.txt
  file.choose())#fichier coda3.txt
)


# Trace plot avec le parametre T


par(mfrow = c(3, 2))
plot(mod2.coda[, grep("^T\\[", varnames(mod2.coda))], 
     trace = TRUE,      
     density = FALSE,    
     auto.layout = FALSE) 
par(mfrow = c(1, 1))

#Diagnostic de Gelman&Rubin


# Test de Gelman.diag

gelman.diag(mod2.coda[, grep("^T\\[", varnames(mod2.coda))])
gelman.plot(mod2.coda[, grep("^T\\[", varnames(mod2.coda))])

#Diagnostic de Raftery&Lewis

raftery.diag(mod2.coda)

# Resultats statistiques et graphiques

summary(mod2.coda)
print(mod2,digits=3)
plot(mod2)

#Affichage d'une partie des resultats 

print(mod2.coda[1,]) 

pdf("mod2_sim.pdf", width = 11, height = 8) 
plot(mod2)                                  
dev.off()


# Effet moyen du traitement par rapport au traitemment de reference

nom_traitements <- c("4LB", "CH", "ACT", "AD", "Laser") 
forestplot(labeltext = nom_traitements, 
           mean  = mod2$summary[22:26, "mean"], 
           lower = mod2$summary[22:26, "2.5%"], 
           upper = mod2$summary[22:26, "97.5%"],
           zero  = 1,            
           xlog  = TRUE,         
           clip  = c(0.1, 15),   
           xlab  = "Odds Ratio (OR)",
           col   = fpColors(box = "royalblue", line = "darkblue", zero = "black"),
           boxsize = 0.4)

forestplot(labeltext = nom_traitements, 
           mean  = mod2$summary[7:11, "mean"], 
           lower = mod2$summary[7:11, "2.5%"], 
           upper = mod2$summary[7:11, "97.5%"],
           zero  = 0,            
           xlog  = FALSE,         
           xlab  = "Log Odds Ratio (Log(OR))",
           col   = fpColors(box = "royalblue", line = "darkblue", zero = "black"),
           boxsize = 0.4)



#Comparaison des densites de la loi a posteriori des trois chaines d'un parametre 
densites.posteriori<-function(name){
  array<-mod2$sims.array[,,]
  plot(density(array[,1,name]),col=1,main="densites pour chaque chaine",sub=name)
  lines(density(array[,2,name]),col=2)
  lines(density(array[,3,name]),col=3)
}
par=mfrow(c(1,2))
densites.posteriori(1) #pour le parametre numero 1 (T[1]) pour les 3 chaines
densites.posteriori(6) #pour le parametre numero 6 (T[6]) pour les 3 chaines
par=mfrow(c(1,1))

# Matrice de classement des traitements


rk_sims <- mod2$sims.list$rk  # On récupère tous les rangs simulés
matrice_rangs <- apply(rk_sims, 2, function(x) table(factor(x, levels=1:6)))
prob_matrice <- t(matrice_rangs / nrow(rk_sims)) 
rownames(prob_matrice) <- c("SoC", "4LB", "CH", "ACT", "AD", "Laser")
colnames(prob_matrice) <- paste("Rang", 1:6)
tableau_final <- as.data.frame(round(prob_matrice, 3))
print(tableau_final)


# Calcul du score SUCRA

prob_cumulees <- t(apply(tableau_final, 1, cumsum))
k <- ncol(tableau_final)
somme_cumulee <- rowSums(prob_cumulees[, 1:(k-1)])
sucra_scores <- somme_cumulee / (k - 1)
print(sort(sucra_scores, decreasing = TRUE))

