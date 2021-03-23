##### installation des librairies
install.packages("stringr")
install.packages("ggplot2")
install.packages("C50")
install.packages("randomForest")
install.packages("naivebayes")
install.packages("e1071")
install.packages("nnet")
install.packages("kknn")
install.packages("pROC")


library(stringr)
library(ggplot2)
library(C50)
library(randomForest)
library(naivebayes)
library(e1071)
library(nnet)
library(kknn)
library(pROC)

attach(clients)


#Nettoyage age
qplot(age, data = clients)

clients <- subset(clients, clients$age >= 17)



#Nettoyage sexe

qplot(sexe, data = clients)

clients <- subset(clients, clients$sexe!="?" & clients$sexe!=" " & clients$sexe!="N/D")

clients$sexe <- str_replace(clients$sexe, "Homme", "M")
clients$sexe <- str_replace(clients$sexe, "Masculin", "M")
clients$sexe <- str_replace(clients$sexe, "Féminin", "F")
clients$sexe <- str_replace(clients$sexe, "Femme", "F")
clients$sexe <- as.factor(clients$sexe)
clients$sexe <- droplevels(clients$sexe)

qplot(sexe, data = clients)

#Nettoyage taux

qplot(taux, data = clients)

clients <- subset(clients, clients$taux >= 544)



#Nettoyage situation familiale

qplot(situationFamiliale, data = clients)
clients <- subset(clients, clients$situationFamiliale != "?" & clients$situationFamiliale != " " & clients$situationFamiliale != "N/D")



clients$situationFamiliale <- droplevels(clients$situationFamiliale)

qplot(situationFamiliale, data = clients)

#Nettoyage enfants a charge
qplot(nbEnfantsAcharge, data = clients)

clients <- subset(clients, clients$nbEnfantsAcharge >= 0)

qplot(nbEnfantsAcharge, data = clients)

###-------------Suppression des doublons dans le fichier immatriculations

doublons <- which(duplicated(immatriculation$immatriculation))
immatriculation<-immatriculation[-doublons,]





qplot(longueur, data =catalogue)
qplot(nbPlaces, data = catalogue)
qplot(nbPortes, data = catalogue)
qplot(couleur, data = catalogue)
qplot(occasion, data = catalogue)

boxplot(puissance~prix, data=catalogue, ylab="valeur de la puissance", xlab="valeur du prix", main="Distribution de la puissance selon le prix")

#-------------------- Categories de voitures

#--creation de 6 categories (citadine, compact, routière, familiale, sportive, berline)

catalogue$categories <- ifelse(catalogue$longueur=="courte","citadine",
                               ifelse(catalogue$longueur=="moyenne","compacte",
                                      ifelse(catalogue$longueur=="longue"& catalogue$nbPlaces== 5& catalogue$puissance<180,"routi?re",
                                             ifelse(catalogue$longueur=="longue"&catalogue$nbPlaces== 7&catalogue$puissance<180,"familiale",
                                                    ifelse(catalogue$longueur=="longue" | catalogue$longueur=="très longue" & catalogue$puissance >180 & catalogue$puissance <300,"sportive",
                                                           ifelse(catalogue$longueur == "très longue" & catalogue$puissance >300, "berline","rien"))))))


 #------ applications au fichiers Immatriculation.csv



 immatriculation$categories <- ifelse(immatriculation$longueur=="courte","citadine",
                                      ifelse(immatriculation$longueur=="moyenne","compacte",
                                             ifelse(immatriculation$longueur=="longue"& immatriculation$nbPlaces== 5& immatriculation$puissance<180,"routière",
                                                    ifelse(immatriculation$longueur=="longue"&immatriculation$nbPlaces== 7&immatriculation$puissance<180,"familiale",
                                                           ifelse(immatriculation$longueur=="longue" | immatriculation$longueur=="très longue" & immatriculation$puissance >180 & immatriculation$puissance <300,"sportive",
                                                                  ifelse(immatriculation$longueur == "très longue" & immatriculation$puissance >300, "berline","rien"))))))


 #----- fusion du fichiers client et Immatriculation

 clients_immatriculations <- merge(immatriculation, clients , by ="immatriculation")
 # fusionne les data frames x et y par la colonne immmatriculation.

 print(clients_immatriculations)



 #----mise en forme des données
 #-------- suppresion de  la première colonne immatriculation car c'est une variable inutile----
 clients_immatriculations<-clients_immatriculations[,-1]

 clients_immatriculations <- subset(clients_immatriculations, select = -marque)
 clients_immatriculations <- subset(clients_immatriculations, select = -nom)
 clients_immatriculations <- subset(clients_immatriculations, select = -puissance)
 clients_immatriculations <- subset(clients_immatriculations, select = -longueur)
 clients_immatriculations <- subset(clients_immatriculations, select = -nbPlaces)
 clients_immatriculations <- subset(clients_immatriculations, select = -nbPortes)
 clients_immatriculations <- subset(clients_immatriculations, select = -couleur)
 clients_immatriculations <- subset(clients_immatriculations, select = -occasion)
 clients_immatriculations <- subset(clients_immatriculations, select = -prix)



 ####-----transformation des données en facteur-----


 clients_immatriculations$categories <- as.factor(clients_immatriculations$categories)
 clients_immatriculations$age <- as.factor(clients_immatriculations$age)
 clients_immatriculations$sexe <- as.factor(clients_immatriculations$sexe)
 clients_immatriculations$situationFamiliale <- as.factor(clients_immatriculations$situationFamiliale)
 clients_immatriculations$nbEnfantsAcharge <- as.factor(clients_immatriculations$nbEnfantsAcharge)
 clients_immatriculations$X2eme.voiture <- as.factor(clients_immatriculations$X2eme.voiture)



 ##############################
 #                            #
 #       1er jeu de test      #
 #                            #
 ##############################


 "clients_immatriculations : sélection des 29014 premières lignes de clients_immatriculations.(70% de données)"


 clients_immatriculations_EA <- clients_immatriculations[1:29014,]


 "clients_immatriculations : s?lection des  derni?res lignes de clients_immatriculations.(30% de donnees)"


 clients_immatriculations_ET <- clients_immatriculations[29015:43521,]

 "suppression de la colonne taux de ce data-frame"
 clients_immatriculations_EA <- subset(clients_immatriculations_EA, select = -taux)
 clients_immatriculations_ET <- subset(clients_immatriculations_ET, select = -taux)

 table(clients_immatriculations_EA$categories)
#############################################################################################################
 table(clients_immatriculations_ET$categories)
#############################################################################################################


 #___________________#
#                   #
#       C5.0        #
#                   #
#___________________#

# Apprentissage du classifeur de type arbre de décision
treeC <- C5.0(categories ~., clients_immatriculations_EA)

print(treeC)

C_class <- predict(treeC, clients_immatriculations_ET, type="class")

table(C_class)
#############################################################################################################



table(clients_immatriculations_ET$categories, C_class)
#############################################################################################################


c_prob <- predict(treeC, clients_immatriculations_ET, type="prob")

# Calcul de l'AUC
c_auc <-multiclass.roc(clients_immatriculations_ET$categories, c_prob)
print (c_auc)
#############################################################################################################

#___________________#
#                   #
#   naive bayes     #
#                   #
#___________________#

# Apprentissage du classifeur de type naive bayes
nb <- naive_bayes(categories~., clients_immatriculations_EA)

# Test du classifieur : classe predite
nb_class <- predict(nb, clients_immatriculations_ET, type="class")
table(nb_class)
#############################################################################################################

# Matrice de confusion
table( clients_immatriculations_ET$categories, nb_class)
#############################################################################################################


# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb, clients_immatriculations_ET, type="prob")



# Calcul de l'AUC
nb_auc <-multiclass.roc(clients_immatriculations_ET$categories, nb_prob)
print (nb_auc)
#############################################################################################################



#___________________#
#                   #
#       svm         #
#                   #
#___________________#

# Apprentissage du classifeur de type svm
svm <- svm(categories~., clients_immatriculations_EA, probability=TRUE)

# Test du classifieur : classe predite
svm_class <- predict(svm, clients_immatriculations_ET, type="response")
svm_class
table(svm_class)
#############################################################################################################



# Matrice de confusion
table(clients_immatriculations_ET$categories, svm_class)
#############################################################################################################


# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm, clients_immatriculations_ET, probability=TRUE)



# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame
svm_prob <- as.data.frame(svm_prob)


# Calcul de l'AUC
svm_auc <-multiclass.roc(clients_immatriculations_ET$categories, svm_prob)
print (svm_auc)
#############################################################################################################


#___________________#
#                   #
#       kknn        #
#                   #
#___________________#

kknn<-kknn(categories~., clients_immatriculations_EA, clients_immatriculations_ET)

# Matrice de confusion
table(clients_immatriculations_ET$categories, kknn$fitted.values)
#############################################################################################################

# Conversion des probabilites en data frame
knn_prob <- as.data.frame(kknn$prob)

knn_auc <-multiclass.roc(clients_immatriculations_ET$categories, knn_prob)
print(knn_auc)
#############################################################################################################

#___________________#
#                   #
#       nnet        #
#                   #
#___________________#


nnet<-nnet(categories ~., clients_immatriculations_EA, size=6)

# Test du classifieur : classe predite
nn_class <- predict(nnet, clients_immatriculations_ET, type="class")
nn_class
table(nn_class)
#############################################################################################################

table(clients_immatriculations_ET$categories, nn_class)
#############################################################################################################


# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nnet, clients_immatriculations_ET, type="raw")
nn_auc <-multiclass.roc(clients_immatriculations_ET$categories, nn_prob)
print(nn_auc)
#############################################################################################################


#___________________#
#                   #
#   randomForest    #
#                   #
#___________________#

##------ on supprime la colonne age qui comporte un trop grand nombre de niveau, empechant l'execution du classifieur

clients_immatriculations_EA <- subset(clients_immatriculations_EA, select = -age)
clients_immatriculations_ET <- subset(clients_immatriculations_ET, select = -age)

RF <- randomForest(categories ~ ., data = clients_immatriculations_EA)

result.RF <- predict(RF,clients_immatriculations_ET, type="response")

table(result.RF)
#############################################################################################################

table(clients_immatriculations_ET$categories, result.RF)
#############################################################################################################

rf_prob <- predict(RF, clients_immatriculations_ET, type="prob")


RF_auc <-multiclass.roc(clients_immatriculations_ET$categories, rf_prob)
print (RF_auc)
#############################################################################################################

##############################
#                            #
#     2eme jeu de test       #
#                            #
##############################


##------ creation de deux nouveaux assembles d'apprentissage et de test
clients_immatriculations_EA2 <- clients_immatriculations[1:29014,]

clients_immatriculations_ET2 <- clients_immatriculations[29015:43521,]

clients_immatriculations_EA2$ctaux<- ifelse(clients_immatriculations_EA2$taux <589, "Faible",
                                            ifelse(clients_immatriculations_EA2$taux <901.7, "Moyen",
                                                   ifelse(clients_immatriculations_EA2$taux < 1147, "Elevé","Très Elevé")))

clients_immatriculations_ET2$ctaux<- ifelse(clients_immatriculations_ET2$taux <589, "Faible",
                                            ifelse(clients_immatriculations_ET2$taux <901.7, "Moyen",
                                                   ifelse(clients_immatriculations_ET2$taux < 1147, "Elevé","Très Elevé")))


clients_immatriculations_EA2$ctaux <- as.factor(clients_immatriculations_EA2$ctaux)
clients_immatriculations_ET2$ctaux <- as.factor(clients_immatriculations_ET2$ctaux)

clients_immatriculations_EA2$taux <- as.factor(clients_immatriculations_EA2$taux)
clients_immatriculations_ET2$taux <- as.factor(clients_immatriculations_ET2$taux)

##-------------Suppression de la colonne taux

clients_immatriculations_EA2 <- subset(clients_immatriculations_EA2, select = -taux)
clients_immatriculations_ET2 <- subset(clients_immatriculations_ET2, select = -taux)


#___________________#
#                   #
#       C5.0        #
#                   #
#___________________#
# Apprentissage du classifeur de type arbre de décision
treeC2 <- C5.0(categories ~., clients_immatriculations_EA2)


print(treeC2)

# Test du classifieur : classe predite
C_class2 <- predict(treeC2, clients_immatriculations_ET2, type="class")

table(C_class2)
#############################################################################################################



# Matrice de confusion
table(clients_immatriculations_ET2$categories, C_class2)
#############################################################################################################


# Test du classifieur : probabilites pour chaque prediction
c_prob2 <- predict(treeC2, clients_immatriculations_ET2, type="prob")



# Calcul de l'AUC
c_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, c_prob2)
print (c_auc2)

#############################################################################################################

#___________________#
#                   #
#   naive bayes     #
#                   #
#___________________#
# Apprentissage du classifeur de type naive bayes
nb2 <- naive_bayes(categories~., clients_immatriculations_EA2)

# Test du classifieur : classe predite
nb_class2 <- predict(nb2, clients_immatriculations_ET2, type="class")
table(nb_class2)
#############################################################################################################


table( clients_immatriculations_ET2$categories, nb_class2)
#############################################################################################################

# Test du classifieur : probabilites pour chaque prediction
nb_prob2 <- predict(nb2, clients_immatriculations_ET2, type="prob")



# Calcul de l'AUC
nb_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, nb_prob2)
print (nb_auc2)
#############################################################################################################

#___________________#
#                   #
#       svm         #
#                   #
#___________________#
# Apprentissage du classifeur de type svm
svm2 <- svm(categories~., clients_immatriculations_EA2, probability=TRUE)

# Test du classifieur : classe predite
svm_class2 <- predict(svm2, clients_immatriculations_ET2, type="response")
table(svm_class2)
#############################################################################################################

# Matrice de confusion
table(clients_immatriculations_ET2$categories, svm_class2)
#############################################################################################################


# Test du classifieur : probabilites pour chaque prediction
svm_prob2 <- predict(svm2, clients_immatriculations_ET2, probability=TRUE)



# Recuperation des probabilites associees aux predictions
svm_prob2 <- attr(svm_prob2, "probabilities")

# Conversion en un data frame
svm_prob2 <- as.data.frame(svm_prob2)


# Calcul de l'AUC
svm_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, svm_prob2)
print (svm_auc2)
#############################################################################################################

#___________________#
#                   #
#       kknn        #
#                   #
#___________________#
kknn2<-kknn(categories~., clients_immatriculations_EA2, clients_immatriculations_ET2)

# Matrice de confusion
table(clients_immatriculations_ET2$categories, kknn2$fitted.values)
#############################################################################################################


# Conversion des probabilites en data frame
knn_prob2 <- as.data.frame(kknn2$prob)

knn_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, knn_prob2)
print(knn_auc2)
#############################################################################################################


#___________________#
#                   #
#       nnet        #
#                   #
#___________________#


nnet2<-nnet(categories ~., clients_immatriculations_EA2, size=7)

# Test du classifieur : classe predite
nn_class2 <- predict(nnet2, clients_immatriculations_ET2, type="class")

table(nn_class2)
#############################################################################################################


# Matrice de confusion
table(clients_immatriculations_ET2$categories, nn_class2)
#############################################################################################################

# Test du classifieur : probabilites pour chaque prediction
nn_prob2 <- predict(nnet2, clients_immatriculations_ET2, type="raw")
nn_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, nn_prob2)
print(nn_auc2)
#############################################################################################################

#___________________#
#                   #
#   randomForest    #
#                   #
#___________________#
##------ on supprime la colonne age qui comporte un trop grand nombre de niveau, empÃªchant l'exÃ©cution du classifieur
clients_immatriculations_EA2 <- subset(clients_immatriculations_EA2, select = -age)
clients_immatriculations_ET2 <- subset(clients_immatriculations_ET2, select = -age)

RF2 <- randomForest(categories ~ ., data = clients_immatriculations_EA2)

result.RF2 <- predict(RF2,clients_immatriculations_ET2, type="response")

table(result.RF2)
#############################################################################################################

table(clients_immatriculations_ET2$categories, result.RF2)
#############################################################################################################


rf_prob2 <- predict(RF2, clients_immatriculations_ET2, type="prob")


RF2_auc <-multiclass.roc(clients_immatriculations_ET2$categories, rf_prob2)
print (RF2_auc)
#############################################################################################################

##############################
#                            #
#     3eme jeu de test       #
#                            #
##############################

#Ce dernier jeu de donnees a pour but de faire coincider les variables entre le  fichier Marketing et clients_immatriculation
#afin de faire apparaitre le taux pour C5.0

##------ creation de deux nouveaux assembles d'apprentissage et de test
clients_immatriculations_EA3 <- clients_immatriculations[1:29014,]

clients_immatriculations_ET3 <- clients_immatriculations[29015:43521,]


# Apprentissage du classifeur de type arbre de decision
treeCFinal <- C5.0(categories ~., clients_immatriculations_EA3)

print(treeCFinal)

C_classFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="class")

table(C_classFinal)
#############################################################################################################

table(clients_immatriculations_ET3$categories, C_classFinal)
#############################################################################################################

# Test du classifieur : probabilites pour chaque prediction
c_probFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="prob")

# Calcul de l'AUC
c_aucFinal <-multiclass.roc(clients_immatriculations_ET3$categories, c_probFinal)
print (c_aucFinal)
#############################################################################################################


#--------------------------------#
# APPLICATION DE LA METHODE C5.0 #
#--------------------------------#


# Visualisation des donnees a predire
View(marketing)

####-----transformation des donnees en facteur-----
marketing$X2eme.voiture <- marketing$X2eme.voiture %>% str_to_upper()

marketing$age <- as.factor(marketing$age)

marketing$taux <- as.factor(marketing$taux)

marketing$nbEnfantsAcharge <- as.factor(marketing$nbEnfantsAcharge)


#=== C5.0 ===#
class.treeCpred <- predict(treeCFinal, marketing)

class.treeCpred

resultat1 <- data.frame(marketing, class.treeCpred)

names(resultat1)[7]= ("Catégorie prédite")

view(resultat1)
#############################################################################################################
