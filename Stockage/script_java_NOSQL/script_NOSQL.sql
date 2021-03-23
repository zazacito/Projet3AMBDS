-------------------------------------------------------
-- Import du fichier Marketing.csv dans ORACLE NOSQL --
-------------------------------------------------------

-- Connexion à l'adresse IP 134.59.152.cent quatorze:443

-- Ceci est le chemin vers notre projet sur la machine virtuelle
[oracle@bigdatalite ~]$ export MYPROJECTHOME=/home/AZALBERT/projetMBDS/

-- Compiler le code java pour importer la table MARKETING à partir du fichier csv
[oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/voiture/DataImportMarketing.java

-- Executer le code java pour importer la table MARKETING à partir du fichier csv
[oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ voiture.DataImportMarketing

/*

****** Dans : executeDDL ********
===========================
Statement was successful:
        drop table MARKETING
Results:
        Plan DropTable MARKETING
Id:                    3634
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 13:33:53 UTC
Ended:                 2021-03-22 13:34:04 UTC
Total tasks:           3
 Successful:           3

****** Dans : executeDDL ********
===========================
Statement was successful:
        Create table MARKETING (CLIENTMARKETINGID INTEGER,AGE STRING,SEXE STRING,TAUX STRING,SITUATIONFAMILIALE STRING,NBENFANTSACHARGE STRING,DEUXIEMEVOITURE STRING,PRIMARY KEY (CLIENTMARKETINGID))
Results:
        Plan CreateTable MARKETING
Id:                    3635
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 13:34:05 UTC
Ended:                 2021-03-22 13:34:05 UTC
Total tasks:           1
 Successful:           1

********************************** Dans : loadmarketingDataFromFile *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************

*/

-- Connection à Oracle NoSQL
[oracle@bigdatalite ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv-> connect store -name kvstore

-- Vérification du contenu de la table MARKETING
kv-> get table -name MARKETING

-- Réponse :

{"CLIENTMARKETINGID":7,"AGE":"59","SEXE":"F","TAUX":"572","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":12,"AGE":"55","SEXE":"M","TAUX":"588","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":2,"AGE":"35","SEXE":"M","TAUX":"223","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":5,"AGE":"80","SEXE":"M","TAUX":"530","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":15,"AGE":"60","SEXE":"M","TAUX":"524","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":4,"AGE":"26","SEXE":"F","TAUX":"420","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":6,"AGE":"27","SEXE":"F","TAUX":"153","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":13,"AGE":"19","SEXE":"F","TAUX":"212","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":18,"AGE":"54","SEXE":"F","TAUX":"452","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":19,"AGE":"35","SEXE":"M","TAUX":"589","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":10,"AGE":"22","SEXE":"M","TAUX":"154","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"1","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":11,"AGE":"79","SEXE":"F","TAUX":"981","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":20,"AGE":"59","SEXE":"M","TAUX":"748","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":3,"AGE":"48","SEXE":"M","TAUX":"401","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":8,"AGE":"43","SEXE":"F","TAUX":"431","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":14,"AGE":"34","SEXE":"F","TAUX":"1112","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":16,"AGE":"22","SEXE":"M","TAUX":"411","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":17,"AGE":"58","SEXE":"M","TAUX":"1192","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":9,"AGE":"64","SEXE":"M","TAUX":"559","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":1,"AGE":"21","SEXE":"F","TAUX":"1396","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
20 rows returned

-- Compiler le code java pour importer la table MARKETING à partir du fichier csv
[oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/voiture/DataImportImmatriculation.java

-- Executer le code java pour importer la table MARKETING à partir du fichier csv
[oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ voiture.DataImportImmatriculation

-- Connection à Oracle NoSQL
[oracle@bigdatalite ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv-> connect store -name kvstore

-- Vérification du contenu de la table MARKETING
kv-> get table -name IMMATRICULATION
-- Réponse
{"IMMATRICULATION":"0 AJ 71","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"25970"}
{"IMMATRICULATION":"0 BH 31","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"0 DQ 29","MARQUE":"Peugeot","NOM":"1007 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"9625"}
{"IMMATRICULATION":"0 EA 32","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"25970"}
{"IMMATRICULATION":"0 HF 24","MARQUE":"Peugeot","NOM":"1007 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"13750"}
{"IMMATRICULATION":"0 IS 25","MARQUE":"Ford","NOM":"Mondeo 1.8","PUISSANCE":"125","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"23900"}
{"IMMATRICULATION":"0 JH 10","MARQUE":"Daihatsu","NOM":"Cuore 1.0","PUISSANCE":"58","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"noir","OCCASION":"false","PRIX":"8850"}
{"IMMATRICULATION":"0 LL 88","MARQUE":"Peugeot","NOM":"1007 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"13750"}
{"IMMATRICULATION":"0 LS 80","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"25970"}
{"IMMATRICULATION":"0 MA 55","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"true","PRIX":"12817"}
{"IMMATRICULATION":"0 NK 32","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"0 OZ 65","MARQUE":"Ford","NOM":"Mondeo 1.8","PUISSANCE":"125","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"23900"}
{"IMMATRICULATION":"0 RA 89","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"50500"}
{"IMMATRICULATION":"0 TD 70","MARQUE":"Fiat","NOM":"Croma 2.2","PUISSANCE":"147","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"24780"}
{"IMMATRICULATION":"0 TX 67","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"12817"}
{"IMMATRICULATION":"0 WN 33","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"0 WQ 28","MARQUE":"Mercedes","NOM":"A200","PUISSANCE":"136","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"25900"}
{"IMMATRICULATION":"0 WT 20","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"12817"}
{"IMMATRICULATION":"1 CH 44","MARQUE":"Peugeot","NOM":"1007 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"13750"}
{"IMMATRICULATION":"1 CT 37","MARQUE":"Mercedes","NOM":"S500","PUISSANCE":"306","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"101300"}
{"IMMATRICULATION":"1 EE 91","MARQUE":"Seat","NOM":"Toledo 1.6","PUISSANCE":"102","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"18880"}
{"IMMATRICULATION":"1 EH 73","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"1 FI 20","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"bleu","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"1 FS 96","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 FY 73","MARQUE":"Renault","NOM":"Laguna 2.0T","PUISSANCE":"170","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"27300"}
{"IMMATRICULATION":"1 MK 66","MARQUE":"Mercedes","NOM":"A200","PUISSANCE":"136","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"25900"}
{"IMMATRICULATION":"1 OM 86","MARQUE":"Mercedes","NOM":"A200","PUISSANCE":"136","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"25900"}
{"IMMATRICULATION":"1 PB 75","MARQUE":"Daihatsu","NOM":"Cuore 1.0","PUISSANCE":"58","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"rouge","OCCASION":"false","PRIX":"8850"}
{"IMMATRICULATION":"1 PD 36","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"1 PI 61","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"1 PL 75","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"1 QT 64","MARQUE":"Volkswagen","NOM":"Golf 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"true","PRIX":"16029"}
{"IMMATRICULATION":"1 RT 46","MARQUE":"Mercedes","NOM":"A200","PUISSANCE":"136","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"25900"}
{"IMMATRICULATION":"1 RT 70","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"1 VZ 24","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"rouge","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"1 WE 48","MARQUE":"Saab","NOM":"9.3 1.8T","PUISSANCE":"150","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"true","PRIX":"27020"}
{"IMMATRICULATION":"1 WL 40","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 WP 18","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"1 YW 94","MARQUE":"Ford","NOM":"Mondeo 1.8","PUISSANCE":"125","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"23900"}
{"IMMATRICULATION":"1 ZC 41","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 ZL 73","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"1 ZY 89","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"10 BP 51","MARQUE":"Mercedes","NOM":"A200","PUISSANCE":"136","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"25900"}
{"IMMATRICULATION":"10 CQ 69","MARQUE":"Audi","NOM":"A3 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"28500"}
{"IMMATRICULATION":"10 DH 66","MARQUE":"Fiat","NOM":"Croma 2.2","PUISSANCE":"147","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"true","PRIX":"17346"}
{"IMMATRICULATION":"10 ER 21","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"10 EW 37","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"10 GT 60","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"10 HY 79","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"50500"}
{"IMMATRICULATION":"10 IU 32","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"10 LW 95","MARQUE":"Saab","NOM":"9.3 1.8T","PUISSANCE":"150","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"27020"}
{"IMMATRICULATION":"10 OD 27","MARQUE":"Saab","NOM":"9.3 1.8T","PUISSANCE":"150","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"27020"}
{"IMMATRICULATION":"10 PW 11","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"35350"}
{"IMMATRICULATION":"10 QS 40","MARQUE":"Renault","NOM":"Laguna 2.0T","PUISSANCE":"170","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"27300"}
{"IMMATRICULATION":"10 RO 47","MARQUE":"Renault","NOM":"Megane 2.0 16V","PUISSANCE":"135","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"22350"}
{"IMMATRICULATION":"10 UH 29","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"10 UT 47","MARQUE":"Renault","NOM":"Vel Satis 3.5 V6","PUISSANCE":"245","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"49200"}
--More--(1~57)
