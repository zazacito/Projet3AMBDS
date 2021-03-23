CREATE EXTERNAL TABLE immatriculation_mongo_chambord
(
id STRUCT<oid:STRING, bsontype:INT>,
  	Immatriculation STRING,
  	Marque STRING,
  	Nom STRING,
    Puissance INT,
  	Longueur STRING,
  	Nbplaces INT,
  	Nbportes INT,
  	Couleur STRING,
  	Occasion STRING,
    Prix INT
)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id",
 "Immatriculation":"immatriculation", "Marque":"marque", "Nom":"nom", "Puissance":"puissance", "Longueur":"longueur", "Nbplaces":"nbplaces", "Nbportes":"nbportes", "Couleur":"couleur","Occasion":"occasion","Prix":"prix"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/concessionaire.immatriculations');

//Supprimer une Table

hive> drop table <table-name>;


//Afficher la Table
describe formatted immatriculation_mongo_chambord;
