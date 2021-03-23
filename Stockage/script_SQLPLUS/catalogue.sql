-- Ajout de la table catalogue dans sql plus pointant vers la table externe située dans Hive

sqlplus AZALBERTBZ2021@ORCL/AZALBERTBZ202101;

select * from CATALOGUE;

drop table CATALOGUE;

CREATE TABLE CATALOGUE
(
    MARQUE    varchar2(30),
    NOM       varchar2(30),
    PUISSANCE varchar2(30),
    LONGUEUR  varchar2(30),
    NBPLACES  varchar2(30),
    NBPORTES  varchar2(30),
    COULEUR   varchar2(30),
    OCCASION  varchar2(30),
    PRIX      varchar2(30)
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG ACCESS PARAMETERS (
    com.oracle.bigdata.tablename=default.CATALOGUE
    )
)
REJECT LIMIT UNLIMITED;

SELECT * FROM CATALOGUE FETCH FIRST 2 ROWS ONLY;