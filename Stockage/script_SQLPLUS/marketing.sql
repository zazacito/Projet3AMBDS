-- Ajout de la table marketing dans sql plus pointant vers la table externe située dans Hive

sqlplus AZALBERTBZ2021@ORCL/AZALBERTBZ202101;

drop table MARKETING;

CREATE TABLE MARKETING
(
    CLIENTMARKETINGID  INTEGER,
    AGE                varchar2(30),
    SEXE               varchar2(30),
    TAUX               varchar2(30),
    SITUATIONFAMILIALE varchar2(30),
    NBENFANTSACHARGE   varchar2(30),
    DEUXIEMEVOITURE    varchar2(30)
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG ACCESS PARAMETERS (
    com.oracle.bigdata.tablename=default.MARKETING
    )
)
REJECT LIMIT UNLIMITED;

SELECT * FROM MARKETING FETCH FIRST 2 ROWS ONLY;