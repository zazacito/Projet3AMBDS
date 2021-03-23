--Creation de la table immatriculations dans hive à partir de la table immatriculations de Oracle No SQL (kvStore)

-- Connexion à Hive
beeline
beeline> !connect jdbc:hive2://localhost:10000

-- Supprimer la table IMMATRICULATION si elle existe déjà
jdbc
:hive2://localhost:10000>
drop table IMMATRICULATION;

-- Création de la table externe IMMATRICULATION pointant vers la table IMMATRICULATION de ORACLE NOSQL (kv)
jdbc
:hive2://localhost:10000> CREATE
EXTERNAL TABLE IMMATRICULATION(
    IMMATRICULATION string,
    MARQUE string,
    NOM string,
    PUISSANCE string,
    LONGUEUR string,
    NBPLACES string,
    NBPORTES string,
    COULEUR string,
    OCCASION string,
    PRIX string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000",
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1",
"oracle.kv.tableName" = "IMMATRICULATION");

-- Vérification du contenu de la table IMMATRICULATION externe dans HIVE
0: jdbc:hive2://localhost:10000>
select *
from IMMATRICULATION;