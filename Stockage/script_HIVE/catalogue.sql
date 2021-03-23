-- Connexion à Hive
beeline
beeline> !connect jdbc:hive2://localhost:10000

-- Supprimer la table IMMATRICULATION si elle existe déjà
jdbc
:hive2://localhost:10000>
drop table CATALOGUE;

-- Création de la table externe catalogue pointant vers le fichier catalogue dans hadoop
jdbc
:hive2://localhost:10000>
CREATE EXTERNAL TABLE CATALOGUE (
    MARQUE string,
    NOM string ,
    PUISSANCE string,
    LONGUEUR string,
    NBPLACES string,
    NBPORTES string,
    COULEUR string,
    OCCASION string,
    PRIX string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/user/AZALBERT/projetMBDS/Catalogue';


-- Vérification du contenu de la table IMMATRICULATION externe dans HIVE
0: jdbc:hive2://localhost:10000>
select *
from CATALOGUE;


