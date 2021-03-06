
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_144")

library("rJava")
library(RJDBC)
library(ggplot2)
library(nnet)
library(kknn)
library(ROCR)
library(pROC)
library(randomForest)
library(C50)
library(e1071)
library(naivebayes)
library(rpart)
library(C50)
library(tree)
library(stringr)

##Connection à la base de données

connexion <- odbcConnect("ORCLPROJETDB_DNS", uid="PROJET", pwd="password1", believeNRows=FALSE)

immatriculation<-sqlQuery(connexion, "SELECT * FROM IMMATRICULATION")
marketing<-sqlQuery(connexion, "SELECT * FROM MARKETING")
catalogue<-sqlQuery(connexion, "SELECT * FROM CATALOGUE")
clients<-sqlQuery(connexion, "SELECT * FROM CLIENTS")


#-----------------------Nettoyage des Données--------------------------#

##Refactorisation données 

clients$age <- as.integer(clients$age)
clients$taux <- as.integer(clients$taux)
clients$situationFamiliale <- as.factor(clients$situationFamiliale)
clients$nbEnfantsAcharge <- as.integer(clients$nbEnfantsAcharge)
clients$X2eme.voiture <- as.logical(clients$X2eme.voiture)
clients$sexe <- as.factor(clients$sexe)
clients$immatriculation <- as.character(clients$immatriculation)
clients <- na.omit(clients)

marketing$age <- as.integer(marketing$age)
marketing$taux <- as.integer(marketing$taux)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.integer(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.logical(marketing$X2eme.voiture)
marketing$sexe <- as.factor(marketing$sexe)
marketing <- na.omit(marketing)

catalogue$marque <- as.character(catalogue$marque)
catalogue$nom <- as.character(catalogue$nom)
catalogue$puissance <- as.integer(catalogue$puissance)
catalogue$longueur <- as.character(catalogue$longueur)
catalogue$nbplaces <- as.integer(catalogue$nbPlaces)
catalogue$nbportes <- as.integer(catalogue$nbPortes)
catalogue$couleur <- as.character(catalogue$couleur)
catalogue$occasion <- as.character(catalogue$occasion)
catalogue$prix <- as.integer(catalogue$prix)
catalogue <- na.omit(catalogue)


immatriculation$marque <- as.character(immatriculation$marque)
immatriculation$nom <- as.character(immatriculation$nom)
immatriculation$puissance <- as.integer(immatriculation$puissance)
immatriculation$longueur <- as.character(immatriculation$longueur)
immatriculation$nbplaces <- as.integer(immatriculation$nbPlaces)
immatriculation$nbportes <- as.integer(immatriculation$nbPortes)
immatriculation$couleur <- as.character(immatriculation$couleur)
immatriculation$occasion <- as.character(immatriculation$occasion)
immatriculation$prix <- as.integer(immatriculation$prix)
immatriculation$immatriculation <- as.character(immatriculation$immatriculation)
immatriculation <- na.omit(immatriculation)

summary(catalogue)
summary(immatriculation)
summary(clients)
summary(marketing)


##Nettoyage Df Clients

#Nettoyage age

boxplot(clients$age, data=clients, main="Boite à Moustache pour l'âge d'un client
        sans Nettoyage des Données")

clients <- subset(clients, clients$age >= 17)

boxplot(clients$age, data=clients, main="Boite à Moustache pour l'âge d'un client
        avec Nettoyage des Données")


#Nettoyage sexe

summary(clients$sexe);
clients <- subset(clients, clients$sexe!="?" & clients$sexe!=" " & clients$sexe!="N/D")

clients$sexe <- str_replace(clients$sexe, "Homme", "M")
clients$sexe <- str_replace(clients$sexe, "Masculin", "M")
clients$sexe <- str_replace(clients$sexe, "Féminin", "F")
clients$sexe <- str_replace(clients$sexe, "Femme", "F")
clients$sexe <- as.factor(clients$sexe)
clients$sexe <- droplevels(clients$sexe)

#Nettoyage taux

summary(clients$taux)
boxplot(clients$taux, data=clients, main="Boite à Moustache pour le taux d'un client
        sans Nettoyage des Données")


clients <- subset(clients, clients$taux >= 544)

summary(clients$taux)
boxplot(clients$taux, data=clients, main="Boite à Moustache pour le taux d'un client
        avec Nettoyage des Données")



#Nettoyage situation familiale

summary(clients$situationFamiliale)

clients <- subset(clients, clients$situationFamiliale != "?" &
                    clients$situationFamiliale != " " & clients$situationFamiliale != "N/D")
clients$situationFamiliale <- droplevels(clients$situationFamiliale)

summary(clients$situationFamiliale)

#Nettoyage enfants a charge

summary(clients$nbEnfantsAcharge)

clients <- subset(clients, clients$nbEnfantsAcharge >= 0)

summary(clients$nbEnfantsAcharge)


#Suppression des doublons 

doublonsClients <- which(duplicated(clients$immatriculation))
client <-clients[-doublonsClients,]

##Nettoyage Df Immatriculations

#Suppression des doublons dans le fichier immatriculations

doublons <- which(duplicated(immatriculation$immatriculation))
immatriculations<-immatriculation[-doublons,]

summary(marketing)
summary(catalogue)
summary(immatriculations)
summary(client)

#-----------------------Catégories Véhicules--------------------------#

#Analyse Exploratoire pour déterminer des catégories

catalogue$longueur <- factor(catalogue$longueur, c("courte", "moyenne", "longue","très longue"))

qplot(longueur, puissance, data=catalogue, 
      main="Longueur de la voiture en fonction de la puissance",
      xlab="Longueur de la Voiture", ylab="Puissance (en Chevaux)",color=nbPlaces)+  geom_jitter(width = 0.4) 



qplot(longueur, puissance, data=immatriculations[0:1000,], 
      main="Longueur de la voiture en fonction de la puissance",
      xlab="Longueur de la Voiture", ylab="Puissance (en Chevaux)",color=nbPlaces)+  geom_jitter(width = 0.4) 


  

#Création de catégories de véhicules


immatriculations$categories <- ifelse(immatriculations$longueur=="courte" & immatriculations$puissance >=55 & immatriculations$puissance <= 90 & immatriculations$nbPlaces== 5,"citadine"  ,
                                      ifelse(immatriculations$longueur=="courte" & immatriculations$puissance > 90 & immatriculations$nbPlaces== 5,"citadine sportive" ,
                                             ifelse(immatriculations$longueur=="moyenne" & immatriculations$puissance >=55 & immatriculations$puissance <= 100 & immatriculations$nbPlaces== 5,"routiere",
                                                    ifelse(immatriculations$longueur=="moyenne" & immatriculations$puissance >=100 & immatriculations$puissance <= 140 & immatriculations$nbPlaces== 5,"routiere sportive",
                                                           ifelse(immatriculations$longueur=="moyenne" & immatriculations$puissance > 140 & immatriculations$nbPlaces== 5,"routiere ultra sportive" ,
                                                                  ifelse( immatriculations$longueur=="très longue" & immatriculations$puissance >=55 & immatriculations$puissance <= 250 & immatriculations$nbPlaces== 5,"berline" ,
                                                                          ifelse( immatriculations$longueur=="très longue" & immatriculations$puissance >=250 & immatriculations$puissance <= 350 & immatriculations$nbPlaces== 5,"berline sportive" ,
                                                                                  ifelse( immatriculations$longueur=="très longue" & immatriculations$puissance > 350 & immatriculations$nbPlaces== 5,"berline ultra sportive" ,
                                                                                          ifelse(immatriculations$longueur=="longue" & immatriculations$puissance >=55 & immatriculations$puissance <= 140  &  immatriculations$nbPlaces== 5,"familliale",
                                                                                                 ifelse(immatriculations$longueur=="longue"  & immatriculations$puissance > 140 & immatriculations$nbPlaces== 5 ,"familliale sportive","aucune" ))))))))))


immatriculations$categories <-  as.factor(immatriculations$categories)
#str(immatriculations$categories)
summary(immatriculations$categories)


catalogue$categories <- ifelse(catalogue$longueur=="courte" & catalogue$puissance >=55 & catalogue$puissance <= 90 & catalogue$nbplaces== 5,"citadine"  ,
                               ifelse(catalogue$longueur=="courte" & catalogue$puissance > 90 & catalogue$nbplaces== 5,"citadine sportive" ,
                                      ifelse(catalogue$longueur=="moyenne" & catalogue$puissance >=55 & catalogue$puissance <= 100 & catalogue$nbplaces== 5,"routiere",
                                             ifelse(catalogue$longueur=="moyenne" & catalogue$puissance >=100 & catalogue$puissance <= 140 & catalogue$nbplaces== 5,"routiere sportive",
                                                    ifelse(catalogue$longueur=="moyenne" & catalogue$puissance > 140 & catalogue$nbplaces== 5,"routiere ultra sportive" ,
                                                           ifelse( catalogue$longueur=="très longue" & catalogue$puissance >=55 & catalogue$puissance <= 250 & catalogue$nbplaces== 5,"berline" ,
                                                                   ifelse( catalogue$longueur=="très longue" & catalogue$puissance >=250 & catalogue$puissance <= 350 & catalogue$nbplaces== 5,"berline sportive" ,
                                                                           ifelse( catalogue$longueur=="très longue" & catalogue$puissance > 350 & catalogue$nbplaces== 5,"berline ultra sportive" ,
                                                                                   ifelse(catalogue$longueur=="longue" & catalogue$puissance >=55 & catalogue$puissance <= 140   ,"familliale",
                                                                                          ifelse(catalogue$longueur=="longue"  & catalogue$puissance > 140 ,"familliale sportive","aucune"))))))))))
catalogue$categories <-  as.factor(catalogue$categories)
str(catalogue$categories)
summary(catalogue$categories)


#Histogrammes permettant de montrer les effectifs pour chacune des catégories
qplot(catalogue$categories, data=catalogue)
qplot(immatriculations$categories, data=immatriculations)

#-----------------------Nettoyage et fusion fichiers--------------------------#




#fusion du fichiers client et Immatriculation

clients_immatriculations <- merge(immatriculations, client , by ="immatriculation")

#Restructuration données

#Suppression de la colonne immatriculations
clients_immatriculations<-clients_immatriculations[,-1]




#-----------------------Création ensemble Apprentissage et Test--------------------------#

#Suppression des colonnes
#Seules les catégories, et les données "humaines" sur les clients nous importent
clients_immatriculations<- subset(clients_immatriculations, select = -nbPlaces)
clients_immatriculations <- subset(clients_immatriculations, select = -nbPortes)
clients_immatriculations <- subset(clients_immatriculations, select = -prix)
clients_immatriculations <- subset(clients_immatriculations, select = -longueur)
clients_immatriculations <- subset(clients_immatriculations, select = -puissance)
clients_immatriculations <- subset(clients_immatriculations, select = -nom)
clients_immatriculations <- subset(clients_immatriculations, select = -marque)
clients_immatriculations <- subset(clients_immatriculations, select = -couleur)
clients_immatriculations <- subset(clients_immatriculations, select = -occasion)



#Factorisation des Colonnes
clients_immatriculations$categories <- as.factor(clients_immatriculations$categories)
clients_immatriculations$age <- as.factor(clients_immatriculations$age)
clients_immatriculations$sexe <- as.factor(clients_immatriculations$sexe)
clients_immatriculations$situationFamiliale <- as.factor(clients_immatriculations$situationFamiliale)
clients_immatriculations$nbEnfantsAcharge <- as.factor(clients_immatriculations$nbEnfantsAcharge)
clients_immatriculations$X2eme.voiture <- as.factor(clients_immatriculations$X2eme.voiture)

clients_immatriculations <- na.omit(clients_immatriculations)
summary(clients_immatriculations)

#Duplication du data set, pour ajout d'une colonne catégorie taux ultérieurement
clients_immatriculations_taux <- clients_immatriculations[0:98246,]
clients_immatriculations <- subset(clients_immatriculations, select = -taux)


#ENSEMBLE D'APPRENTISSAGE
#clients_immatriculations_EA : sélection des 29014 premières lignes de clients_immatriculations.(70% de données)"
clients_immatriculations_EA <- clients_immatriculations[1:68773,]

#ENSEMBLE DE TEST
#clients_immatriculations_ET : sélection des  dernières lignes de clients_immatriculations.(30% de données)"
clients_immatriculations_ET <- clients_immatriculations[68773:98246,]

summary(clients_immatriculations_EA)
summary(clients_immatriculations_ET)



#-----------------------Classifieurs--------------------------#

#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#


kknn6<-kknn(categories~., clients_immatriculations_EA, clients_immatriculations_ET)

# Matrice de confusion
table(clients_immatriculations_ET$categories, kknn6$fitted.values)

# Conversion des probabilites en data frame
knn_prob <- as.data.frame(kknn6$prob)

knn_auc <-multiclass.roc(clients_immatriculations_ET$categories, knn_prob)
print(knn_auc)

#-----------------#
# NEURAL NETWORKS #
#-----------------#

nnet5<-nnet(categories ~., clients_immatriculations_EA, size=6)

# Test du classifieur : classe predite
nn_class <- predict(nnet5, clients_immatriculations_ET, type="class")
nn_class
table(nn_class)

# Matrice de confusion
table(clients_immatriculations_ET$categories, nn_class)

# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nnet5, clients_immatriculations_ET, type="raw")
nn_auc <-multiclass.roc(clients_immatriculations_ET$categories, nn_prob)
print(nn_auc)


#----------------#
# RANDOM FORESTS #
#----------------#

clients_immatriculations_EA_RF <- subset(clients_immatriculations_EA, select = -AGE)
# Apprentissage du classifeur de type random forest
rf <- randomForest(categories~., clients_immatriculations_EA_RF)

# Test du classifieur : classe predite
rf_class <- predict(rf,clients_immatriculations_ET, type="response")
table(rf_class)

# Matrice de confusion
table(clients_immatriculations_ET$categories, rf_class)

# Test du classifieur : probabilites pour chaque prediction
rf_prob <- predict(rf, clients_immatriculations_ET , type="prob")
rf_auc <-multiclass.roc(clients_immatriculations_ET$categories, rf_prob)
print(rf_auc)


#-------------#
# NAIVE BAYES #
#-------------#

# Apprentissage du classifeur de type naive bayes
nb <- naive_bayes(categories~., clients_immatriculations_EA)

# Test du classifieur : classe predite
nb_class <- predict(nb, clients_immatriculations_ET, type="class")
table(nb_class)

# Matrice de confusion
table( clients_immatriculations_ET$categories, nb_class)

# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb,  clients_immatriculations_ET, type="prob")
nb_auc <- multiclass.roc(clients_immatriculations_ET$categories, nb_prob)
print(nb_auc)

#-------------#
#      SVM    #
#-------------#

# Apprentissage du classifeur de type svm
svm <- svm(categories~., clients_immatriculations_EA, probability=TRUE)
svm

# Test du classifieur : classe predite
svm_class <- predict(svm, clients_immatriculations_ET, type="response")
svm_class
table(svm_class)

# Matrice de confusion
table(clients_immatriculations_ET$categories, svm_class)

# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm, clients_immatriculations_ET, probability=TRUE)


# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame 
svm_prob <- as.data.frame(svm_prob)

# Calcul de l'AUC
svm_auc <-multiclass.roc(clients_immatriculations_ET$categories, svm_prob)
print (svm_auc)





#-----------------------Catégories Taux--------------------------#

#boite a moustache du taux 

boxplot(clients_immatriculations_taux$TAUX, data=clients_immatriculations,
        main ="Taux"
        ,col=c("blue"))

summary(clients_immatriculations_taux$TAUX)

#Création de categorie de taux 


clients_immatriculations_taux$cateTaux<- ifelse(clients_immatriculations_taux$TAUX < 420 ,"Faible",
                                           ifelse(clients_immatriculations_taux$TAUX <607.1, "Moyen",
                                                  ifelse(clients_immatriculations_taux$TAUX <823, "Elevée", "Très élevée")))

clients_immatriculations_taux$cateTaux <- as.factor(clients_immatriculations_taux$cateTaux)

summary (clients_immatriculations_taux$cateTaux)

clients_immatriculations_taux <- subset(clients_immatriculations_taux, select = -TAUX)


#ENSEMBLE D'APPRENTISSAGE
#clients_immatriculations_EA : sélection des 29014 premières lignes de clients_immatriculations.(70% de données)"
clients_immatriculations_EA_taux <- clients_immatriculations_taux[1:68773,]

#ENSEMBLE DE TEST
#clients_immatriculations_ET : sélection des  dernières lignes de clients_immatriculations.(30% de données)"
clients_immatriculations_ET_taux <- clients_immatriculations_taux[68773:98246,]

summary(clients_immatriculations_EA_taux)
summary(clients_immatriculations_ET_taux)



#-----------------------Classifieurs avec le taux--------------------------#

#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#


kknn6_taux<-kknn(categories~., clients_immatriculations_EA_taux, clients_immatriculations_ET_taux)

# Matrice de confusion
table(clients_immatriculations_ET_taux$categories, kknn6_taux$fitted.values)

# Conversion des probabilites en data frame
knn_prob_taux <- as.data.frame(kknn6_taux$prob)

knn_auc_taux <-multiclass.roc(clients_immatriculations_ET_taux$categories, knn_prob_taux)
print(knn_auc_taux)

#-----------------#
# NEURAL NETWORKS #
#-----------------#

nnet5_taux<-nnet(categories ~., clients_immatriculations_EA_taux, size=7)

# Test du classifieur : classe predite
nn_class_taux<- predict(nnet5_taux, clients_immatriculations_ET_taux, type="class")
nn_class_taux
table(nn_class_taux)

# Matrice de confusion
table(clients_immatriculations_ET_taux$categories, nn_class_taux)

# Test du classifieur : probabilites pour chaque prediction
nn_prob_taux <- predict(nnet5_taux, clients_immatriculations_ET_taux, type="raw")
nn_auc_taux <-multiclass.roc(clients_immatriculations_ET_taux$categories, nn_prob_taux)
print(nn_auc_taux)


#----------------#
# RANDOM FORESTS #
#----------------#

clients_immatriculations_EA_taux_RF <- subset(clients_immatriculations_EA_taux, select = -AGE)
# Apprentissage du classifeur de type random forest
rf_taux <- randomForest(categories~., clients_immatriculations_EA_taux_RF)

# Test du classifieur : classe predite
rf_class_taux <- predict(rf_taux,clients_immatriculations_ET_taux, type="response")
table(rf_class_taux)

# Matrice de confusion
table(clients_immatriculations_ET_taux$categories, rf_class_taux)

# Test du classifieur : probabilites pour chaque prediction
rf_prob_taux <- predict(rf_taux, clients_immatriculations_ET_taux , type="prob")
rf_auc_taux <-multiclass.roc(clients_immatriculations_ET_taux$categories, rf_prob_taux)
print(rf_auc_taux)


#-------------#
# NAIVE BAYES #
#-------------#

# Apprentissage du classifeur de type naive bayes
nb_taux <- naive_bayes(categories~., clients_immatriculations_EA_taux)

# Test du classifieur : classe predite
nb_class_taux <- predict(nb_taux, clients_immatriculations_ET_taux, type="class")
table(nb_class_taux)

# Matrice de confusion
table( clients_immatriculations_ET_taux$categories, nb_class_taux)

# Test du classifieur : probabilites pour chaque prediction
nb_prob_taux <- predict(nb_taux,  clients_immatriculations_ET_taux, type="prob")
nb_auc_taux <- multiclass.roc(clients_immatriculations_ET_taux$categories, nb_prob_taux)
print(nb_auc_taux)


#-------------#
#      SVM    #
#-------------#

# Apprentissage du classifeur de type svm
svm <- svm(categories~., clients_immatriculations_EA_taux, probability=TRUE)
svm


# Test du classifieur : classe predite
svm_class <- predict(svm, clients_immatriculations_ET_taux, type="response")
svm_class
table(svm_class)

# Matrice de confusion
table(clients_immatriculations_ET_taux$categories, svm_class)

# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm, clients_immatriculations_ET_taux, probability=TRUE)


# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame 
svm_prob <- as.data.frame(svm_prob)


# Calcul de l'AUC
svm_auc <-multiclass.roc(clients_immatriculations_ET_taux$categories, svm_prob)
print (svm_auc)


#--------------------------------------------#
# APPLICATION DE LA METHODE NEURAL NETWORKS #
#------------------------------------------#

## Application des catégories de taux au fichier marketing

#Création de categorie de taux 


marketing$cateTaux<- ifelse(marketing$TAUX < 420 ,"Faible",
                                                ifelse(marketing$TAUX <607.1, "Moyen",
                                                       ifelse(marketing$TAUX <823, "Elevée", "Très élevée")))

marketing$cateTaux <- as.factor(marketing$cateTaux)
marketing$SEXE <- as.factor(marketing$SEXE)
marketing$SITUATIONFAMILIALE <- as.factor(marketing$SITUATIONFAMILIALE)
marketing$DEUXIEMEVOITURE <- as.factor(marketing$DEUXIEMEVOITURE)
marketing$AGE <- as.factor(marketing$AGE)
marketing$NBENFANTSACHARGE <- as.factor(marketing$NBENFANTSACHARGE)

summary(marketing)

marketingResultat <- marketing
marketing <- subset(marketing, select = -TAUX)


#Apprentissage
nnet5_marketing<-nnet(categories ~., clients_immatriculations_taux, size=7)

#Classification
catégorie_prédite<- predict(nnet5_marketing, marketing, type="class")
catégorie_prédite
table(catégorie_prédite)

# Recuperation des probabilites pour chaque prediction
nn_prob_marketing <- predict(nnet5_marketing, marketing, type="raw")

nn_prob_marketing



resultat <- data.frame(marketingResultat,catégorie_prédite,nn_prob_marketing)


#---------------------------------#
# ENREGISTREMENT DES PREDICTIONS  #
#---------------------------------#
# Enregistrement du fichier de resultats au format csv
write.table(resultat, file='predictions.csv', sep="\t", dec=".", row.names = F)


