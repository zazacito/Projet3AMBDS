-- Connection à la machine virtuelle via le terminal sur Mac OCCASION
ssh -p 9922 avictor@135.125.106.207
Ahcaezeix4

-- Ajout du fichier C02.csv sur la machine distante depuis mon terminal
scp -P 9922 CO2_group8.csv avictor@135.125.106.207:~/

-- Vérification de l'Ajout
avictor@vps-f1f17a1e:~$ ls

--Déplacment du fichier vers mon répertoire utilisateur dans HDFS
hadoop fs -put CO2_group8.csv /user/avictor/

--Vérification que le fichier csv a bien été ajouté dans mon répertoire HDFS
hadoop fs -ls /user/avictor/
Reponse:
Found 5 items
-rw-r--r--   1 avictor studentgroup      38916 2021-03-26 13:32 /user/avictor/CO2_group8.csv
-rw-r--r--   1 avictor studentgroup      10310 2021-02-15 14:19 /user/avictor/anagrame.txt
-rw-r--r--   1 avictor studentgroup         78 2021-02-15 15:49 /user/avictor/graph_input.txt
-rw-r--r--   1 avictor studentgroup       1669 2021-02-15 11:19 /user/avictor/poeme2.txt
drwxr-xr-x   - avictor studentgroup          0 2021-02-15 15:49 /user/avictor/results


--Ajout des fichiers.java sur la machine virtuelle, depuis mon terminal
scp -P 9922 Car.java avictor@135.125.106.207:~/
scp -P 9922 CarMap.java avictor@135.125.106.207:~/
scp -P 9922 CarReduce.java avictor@135.125.106.207:~/

-- Vérification de l'Ajout
avictor@vps-f1f17a1e:~$ ls

--Compilation du code
avictor@vps-f1f17a1e:~$  javac Car.java CarMap.java CarReduce.java

--Construisez la hierarchie du .jar et y déplacez le code compilé 
avictor@vps-f1f17a1e:~$ mkdir -p org/car
avictor@vps-f1f17a1e:~$ mv Car*.class org/car

--Vérification que les fichiers ont bien été déplacés
avictor@vps-f1f17a1e:~/org/car$ ls

--Génération du.jar
avictor@vps-f1f17a1e:~ jar -cvf CO2.jar -C . org

--Execution du Programme
avictor@vps-f1f17a1e:~$ hadoop jar CO2.jar org.car.Car  /user/avictor/CO2_group8.csv /user/avictor/results/Projet3A

--Lecture des résultats
avictor@vps-f1f17a1e:~$ hadoop fs -ls /user/avictor/results/Projet3A
Found 2 items
-rw-r--r--   1 avictor studentgroup          0 2021-03-26 14:22 /user/avictor/results/Projet3A/_SUCCESS
-rw-r--r--   1 avictor studentgroup        396 2021-03-26 14:22 /user/avictor/results/Projet3A/part-r-00000

avictor@vps-f1f17a1e:~$ hadoop fs -cat /user/avictor/results/Projet3A/part-r-00000
AUDI	-2400	26	191
BENTLEY	0	84	102
BMW	-631	39	80
CITROEN	-6000	0	347
DS	-3000	16	159
HYUNDAI	-4000	8	151
JAGUAR	-6000	0	271
KIA	-3000	15	132
LAND	0	69	78
MERCEDES	7790	187	749
MINI	-3000	21	126
MITSUBISHI	0	40	98
NISSAN	5802	160	681
PEUGEOT	-3000	15	144
PORSCHE	0	69	89
RENAULT	-6000	0	206
SKODA	-666	27	98
SMART	-6000	0	191
TESLA	-6000	0	245
TOYOTA	0	32	43
VOLKSWAGEN	-1714	23	96
VOLVO	0	42	72


--Export des résultats
avictor@vps-f1f17a1e:~$ hadoop fs -get /user/avictor/results/Projet3A/part-r-00000 

--Copie du fichier de résultat sur ma machine
victorazalbert1@MacBook-Pro MapReduce % scp -P 9922 avictor@135.125.106.207:~/part-r-00000 ./

--Conversion en fichier csv
import-csv .\part-r-00000 -delimiter "`t" | export-csv resultMapReduce.csv -NoTypeInformation

