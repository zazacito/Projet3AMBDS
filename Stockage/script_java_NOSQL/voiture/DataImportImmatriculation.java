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

public class DataImportImmatriculation {
    private final KVStore store;
    private final String tabImmatriculation = "IMMATRICULATION";
    private final String pathToCSVFile = "/home/CAO/projetMBDS/Immatriculations.csv";

    /**
     * Runs the DDL command line program.
     */
    public static void main(String args[]) {
        try {
            DataImportImmatriculation immatriculation = new DataImportImmatriculation(args);
            immatriculation.initImmatriculationTablesAndData(immatriculation);
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    /**
     * Parses command line args and opens the KVStore.
     */
    DataImportImmatriculation(String[] argv) {
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
        La méthode initImmatriculationTablesAndData permet :
        - de supprimer les tables si elles existent
        - de créer des tables
        - de charger les données des immatriculations
    **/
    public void initImmatriculationTablesAndData(DataImportImmatriculation immatriculation) {
        immatriculation.dropImmatriculationTable();
        immatriculation.createImmatriculationTable();
        immatriculation.loadimmatriculationDataFromFile(pathToCSVFile);
    }

    /**
     * public void dropImmatriculationTable()
     * M&thode de suppression de la table immatriculation.
     */
    public void dropImmatriculationTable() {
        String statement = null;

        statement = "drop table " + tabImmatriculation;
        executeDDL(statement);
    }

    /**
     * public void createImmatriculationTable()
     * M&thode de création de la table immatriculation.
     */
    public void createImmatriculationTable() {
        String statement = null;
        statement = "Create table " + tabImmatriculation + " ("
                + "IMMATRICULATION STRING,"
                + "MARQUE STRING,"
                + "NOM STRING,"
                + "PUISSANCE STRING,"
                + "LONGUEUR STRING,"
                + "NBPLACES STRING,"
                + "NBPORTES STRING,"
                + "COULEUR STRING,"
                + "OCCASION STRING," //boolean mais on conserve en string
                + "PRIX STRING,"
                + "PRIMARY KEY (IMMATRICULATION))";
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

    private void insertAimmatriculationRow(String immatriculationID, String marque, String nom, String puissance, String longueur, String nbPlaces, String nbPortes, String couleur, String occasion, String prix) {
        //TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        String statement = null;
        System.out.println("********************************** Dans : insertAimmatriculationRow *********************************");

        try {
            TableAPI tableH = store.getTableAPI();
            // The name you give to getTable() must be identical
            // to the name that you gave the table when you created
            // the table using the CREATE TABLE DDL statement.
            Table immatriculationTable = tableH.getTable(tabImmatriculation);
            // Get a Row instance
            Row immatriculationRow = immatriculationTable.createRow();
            // Now put all of the cells in the row.
            // This does NOT actually write the data to
            // the store.

            // Create one row
            immatriculationRow.put("immatriculation", immatriculationID);
            immatriculationRow.put("marque", marque);
            immatriculationRow.put("nom", nom);
            immatriculationRow.put("puissance", puissance);
            immatriculationRow.put("longueur", longueur);
            immatriculationRow.put("nbPlaces", nbPlaces);
            immatriculationRow.put("nbPortes", nbPortes);
            immatriculationRow.put("couleur", couleur);
            immatriculationRow.put("occasion", occasion);
            immatriculationRow.put("prix", prix);

            // Now write the table to the store.
            // "item" is the row's primary key. If we had not set that value,
            // this operation will throw an IllegalArgumentException.
            tableH.put(immatriculationRow, null, null);

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    /**
     * void loadimmatriculationDataFromFile(String immatriculationDataFileName)
     * cette methodes permet de charger les immatriculations depuis le fichier
     * appelé immatriculation.csv.
     * Pour chaque immatriculation chargée, la
     * méthode insertAimmatriculationRow sera appélée
     */
    void loadimmatriculationDataFromFile(String immatriculationDataFileName) {
        InputStreamReader ipsr;
        BufferedReader br = null;
        InputStream ips;
        // Variables pour stocker les données lues d'un fichier.
        String ligne;
        System.out.println("********************************** Dans : loadimmatriculationDataFromFile *********************************");
        /* parcourir les lignes du fichier texte et découper chaque ligne */
        try {
            ips = new FileInputStream(immatriculationDataFileName);
            ipsr = new InputStreamReader(ips);
            br = new BufferedReader(ipsr);
            /* open text file to read data */
            //parcourir le fichier ligne par ligne et découper chaque ligne en
            //morceau séparés par le symbole ;
            while ((ligne = br.readLine()) != null) {
                //int situationFamiliale, 2eme voiture, nbPortes, prix;
                //String immatriculation, age, sexe,  nbEnfantsAcharge,  couleur, occasion, ;
                ArrayList<String> immatriculationRecord = new ArrayList<String>();
                StringTokenizer val = new StringTokenizer(ligne, ",");
                while (val.hasMoreTokens()) {
                    immatriculationRecord.add(val.nextToken().toString());
                }
                String immatriculationID = immatriculationRecord.get(0);
                String marque = immatriculationRecord.get(1);
                String nom = immatriculationRecord.get(2);
                String puissance = immatriculationRecord.get(3);
                String longueur = immatriculationRecord.get(4);
                String nbPlaces = immatriculationRecord.get(5);
                String nbPortes = immatriculationRecord.get(6);
                String couleur = immatriculationRecord.get(7);
                String occasion = immatriculationRecord.get(8);
                String prix = immatriculationRecord.get(9);
                // Add the immatriculation in the KVStore
                this.insertAimmatriculationRow(immatriculationID, marque, nom, puissance, longueur, nbPlaces, nbPortes, couleur, occasion, prix);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
