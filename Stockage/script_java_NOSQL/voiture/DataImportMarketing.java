package voiture;

import oracle.kv.*;
import oracle.kv.table.Row;
import oracle.kv.table.Table;
import oracle.kv.table.TableAPI;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class DataImportMarketing {
    private final KVStore store;
    private final String tabMarketing = "MARKETING";
    private final String pathToCSVFile = "/home/CAO/projetMBDS/Marketing.csv";
    private int clientID = 1;

    /**
     * Runs the DDL command line program.
     */
    public static void main(String args[]) {
        try {
            DataImportMarketing mark = new DataImportMarketing(args);
            mark.initMarketingTablesAndData(mark);
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    /**
     * Parses command line args and opens the KVStore.
     */
    DataImportMarketing(String[] argv) {
        String storeName = "kvstore";
        String hostName = "localhost";
        String hostPort = "5000";
        final int nArgs = argv.length;
        int argc = 0;
        store = KVStoreFactory.getStore
                (new KVStoreConfig(storeName, hostName + ":" + hostPort));
    }

    /**
     * Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
     */
    private void displayResult(StatementResult result, String statement) {
        System.out.println("===========================");
        if (result.isSuccessful()) {
            System.out.println("Statement was successful:\n\t" +
                    statement);
            System.out.println("Results:\n\t" + result.getInfo());
        } else if (result.isCancelled()) {
            System.out.println("Statement was cancelled:\n\t" +
                    statement);
        } else {
            /*
             * statement was not successful: may be in error, or may still
             * be in progress.
             */
            if (result.isDone()) {
                System.out.println("Statement failed:\n\t" + statement);
                System.out.println("Problem:\n\t" +
                        result.getErrorMessage());
            } else {
                System.out.println("Statement in progress:\n\t" +
                        statement);
                System.out.println("Status:\n\t" + result.getInfo());
            }
        }
    }

    /*
        La méthode initMarketingTablesAndData permet :
        - de supprimer les tables si elles existent
        - de créer des tables
        - de charger les données des marketings
    **/
    public void initMarketingTablesAndData(DataImportMarketing mark) {
        mark.dropMarketingTable();
        mark.createMarketingTable();
        mark.loadmarketingDataFromFile(pathToCSVFile);
    }

    /**
     * public void dropMarketingTable()
     * M&thode de suppression de la table marketing.
     */
    public void dropMarketingTable() {
        String statement = null;

        statement = "drop table " + tabMarketing;
        executeDDL(statement);
    }

    /**
     * public void createMarketingTable()
     * M&thode de création de la table marketing.
     */
    public void createMarketingTable() {
        String statement = null;
        statement = "Create table " + tabMarketing + " ("
                + "CLIENTMARKETINGID INTEGER,"
                + "AGE STRING,"
                + "SEXE STRING,"
                + "TAUX STRING,"
                + "SITUATIONFAMILIALE STRING,"
                + "NBENFANTSACHARGE STRING,"
                + "DEUXIEMEVOITURE STRING,"
                + "PRIMARY KEY (CLIENTMARKETINGID))";
        executeDDL(statement);
    }

    /**
     * public void executeDDL(String statement)
     * méthode générique pour executer les commandes DDL
     */
    public void executeDDL(String statement) {
        TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;

        System.out.println("****** Dans : executeDDL ********");
        try {
            /*
             * Add a table to the database.
             * Execute this statement asynchronously.
             */
            result = store.executeSync(statement);
            displayResult(result, statement);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    private void insertAmarketingRow(String age, String sexe, String taux, String situationFamiliale, String nbEnfantsAcharge, String deuxiemeVoiture) {
        //TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        String statement = null;
        System.out.println("********************************** Dans : insertAmarketingRow *********************************");

        try {
            TableAPI tableH = store.getTableAPI();
            // The name you give to getTable() must be identical
            // to the name that you gave the table when you created
            // the table using the CREATE TABLE DDL statement.
            Table marketingTable = tableH.getTable(tabMarketing);
            // Get a Row instance
            Row marketingRow = marketingTable.createRow();
            // Now put all of the cells in the row.
            // This does NOT actually write the data to
            // the store.

            // Create one row 
            marketingRow.put("clientMarketingID", clientID);
            marketingRow.put("age", age);
            marketingRow.put("sexe", sexe);
            marketingRow.put("taux", taux);
            marketingRow.put("situationFamiliale", situationFamiliale);
            marketingRow.put("nbEnfantsAcharge", nbEnfantsAcharge);
            marketingRow.put("deuxiemeVoiture", deuxiemeVoiture);
            // Now write the table to the store.
            // "item" is the row's primary key. If we had not set that value,
            // this operation will throw an IllegalArgumentException.
            tableH.put(marketingRow, null, null);
            clientID++;

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    /**
     * void loadmarketingDataFromFile(String marketingDataFileName)
     * cette methodes permet de charger les marketings depuis le fichier
     * appelé marketing.csv.
     * Pour chaque marketing chargée, la
     * méthode insertAmarketingRow sera appélée
     */
    void loadmarketingDataFromFile(String marketingDataFileName) {
        InputStreamReader ipsr;
        BufferedReader br = null;
        InputStream ips;
        // Variables pour stocker les données lues d'un fichier. 
        String ligne;
        System.out.println("********************************** Dans : loadmarketingDataFromFile *********************************");
        /* parcourir les lignes du fichier texte et découper chaque ligne */
        try {
            ips = new FileInputStream(marketingDataFileName);
            ipsr = new InputStreamReader(ips);
            br = new BufferedReader(ipsr);
            /* open text file to read data */
            //parcourir le fichier ligne par ligne et découper chaque ligne en 
            //morceau séparés par le symbole ;
            br.readLine();
            String line = null;
            while ((line = br.readLine()) != null) {
                //int situationFamiliale, 2eme voiture, nbPortes, prix; 
                //String marketing, age, sexe,  nbEnfantsAcharge,  couleur, occasion, ;
                ArrayList<String> marketingRecord = new ArrayList<String>();
                StringTokenizer val = new StringTokenizer(line, ",");
                while (val.hasMoreTokens()) {
                    marketingRecord.add(val.nextToken().toString());
                }
                String age = marketingRecord.get(0);
                String sexe = marketingRecord.get(1);
                String taux = marketingRecord.get(2);
                String situationFamiliale = marketingRecord.get(3);
                String nbEnfantsAcharge = marketingRecord.get(4);
                String deuxiemeVoiture = marketingRecord.get(5);
                // Add the marketing in the KVStore
                this.insertAmarketingRow(age, sexe, taux, situationFamiliale, nbEnfantsAcharge, deuxiemeVoiture);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
