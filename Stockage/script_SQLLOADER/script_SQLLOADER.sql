--Ajout des données du fichier client.csv via SQL LOADER

sqlplus AZALBERTBZ2021@ORCL/AZALBERTZ202101

DROP TABLE CLIENT;

CREATE TABLE CLIENT_8(
    AGE varchar2(30), 
    SEXE varchar2(30), 
    TAUX varchar2(30), 
    SITUATIONFAMILIALE varchar2(30), 
    NBENFANTSACHARGE varchar2(30), 
    XVOITURE varchar2(30), 
    IMMATRICULATION varchar2(30)
    );

exit

--Table : client
sqlldr AZALBERTBZ2021@ORCL/AZALBERTBZ202101 control=$MYPROJECTHOME/projetMBDS/SQLLOADER/control_clients.ctl 
log=$MYPROJECTHOME/projetMBDS/SQLLOADER/track_clients.log skip=1


select * from CLIENT_8 LIMIT 10;