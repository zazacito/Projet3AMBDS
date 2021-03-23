-- Ajout du fichier catalogue.csv dans le hdfs

export MYPROJECTHOME=/home/Azalbert/

-- suppressionn du fichier si on souhaite le remplacer
hadoop fs -rm -r /user/Azalbert

hadoop fs -mkdir /user/Azalbert
hadoop fs -mkdir /user/Azalbert/projetMBDS
hadoop fs -mkdir /user/Azalbert/projetMBDS/Catalogue

hadoop fs -put $MYPROJECTHOME/projetMBDS/Catalogue.csv /user/Azalbert/projetMBDS/Catalogue

hadoop fs -ls /user/Azalbert/projetMBDS/Catalogue