$ sqlplus /nolog

SQL> define MYDBUSER=PROJET
SQL> define MYDB=orcl
SQL> define MYDBUSERPASS=password1
SQL> define MYCDBUSER=system
SQL> connect &MYCDBUSER@&MYDB/
Enter password:welcome1


Connected.
SQL> CREATE USER &MYDBUSER IDENTIFIED BY &MYDBUSERPASS default tablespace users temporary tablespace temp;
old   1: CREATE USER &MYDBUSER IDENTIFIED BY &MYDBUSERPASS default tablespace users temporary tablespace temp
new   1: CREATE USER PROJET IDENTIFIED BY password1 default tablespace users temporary tablespace temp

User created.

SQL> grant dba to &MYDBUSER;
old   1: grant dba to &MYDBUSER
new   1: grant dba to PROJET

Grant succeeded.

SQL> alter user &MYDBUSER quota unlimited on users;
old   1: alter user &MYDBUSER quota unlimited on users
new   1: alter user PROJET quota unlimited on users

User altered.

