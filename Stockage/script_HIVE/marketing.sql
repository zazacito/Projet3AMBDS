--Creation de la table marketing dans hive à partir de la table marketing de Oracle No SQL (kvStore)

-- Connexion à Hive
beeline
beeline> !connect jdbc:hive2://localhost:10000

-- Supprimer la table MARKETING si elle existe déjà
drop table MARKETING;

-- Création de la table externe MARKETING pointant vers la table MARKETING de ORACLE NOSQL (kv)
CREATE EXTERNAL TABLE MARKETING(
    CLIENTMARKETINGID int,
    AGE string ,
    SEXE string,
    TAUX string,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE string,
    DEUXIEMEVOITURE string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000",
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1",
"oracle.kv.tableName" = "MARKETING");

-- Vérification du contenu de la table MARKETING externe dans HIVE
select *
from MARKETING;
