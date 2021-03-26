package org.car;

import java.util.Arrays;
import java.util.Iterator;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;
	
public class CarMap extends Mapper<Object, Text, Text, Text> {
		
	protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		//on ne prend pas en compte la première ligne qui est le titre des colonnes
		if (value.toString().contains("Marque")){ 
			return;
		}

		String line = value.toString(); 
		//On foit remplacer tous les espaces par de "vrais" espaces
		line = line.replaceAll("\\u00a0"," ");
		
		//on sépare les données
		String[] splitted_line = line.split(","); 

		// Recuperation de la colonne marque 
		String marque;
		String[] splitted_space = splitted_line[1].split("\\s+"); 
		//Seul le premier mot correspond au nom de la marque
		marque = splitted_space[0];
		
		//Certaines marques commencent par des guillemets donc on les enleve
		marque = marque.replace("\"", "");

		// Recuperation de la colonne Bonus/Malus
        String malus_bonus = splitted_line[2];
		
		//On modifie toutes les valeurs "sales" pour avoir un entier
		malus_bonus = malus_bonus.replaceAll(" ", "").replace("€1", "").replace("€", "").replace("\"", "");

		// On traite les cas particuliers : 
		if (malus_bonus.equals("150kW(204ch)") || malus_bonus.equals("100kW(136ch)"))
		{
			return;
		}

		if (malus_bonus.length() == 1){
			malus_bonus="0"; 
		} 

		// Recuperation de la colonne cout energie
        	String cout = splitted_line[4];
		//On separe les valeurs par les espaces
		String[] cout_splitted = cout.split(" ");
		
		//La taille du tableau est doit de 2 ou 3 on ignore seulement la derbière valeur qui est le symbole €
		if(cout_splitted.length == 2){  
			cout = cout_splitted[0];
		} else if(cout_splitted.length == 3){ 
			cout= cout_splitted[0] + cout_splitted[1];
		}

		// Recuperation de la colonne Rejet CO2
		String rejet = splitted_line[3];

		//Cast des valeurs en int
		int malus_bonus_int = Integer.parseInt(malus_bonus);
		int rejet_int = Integer.parseInt(rejet);
		int cout_int = Integer.parseInt(cout);
	
		// clé/valeurs -> clé = marque et valeur -> le reste
		String new_value = String.valueOf(malus_bonus_int) + "|" +  String.valueOf(rejet_int) + "|" + String.valueOf(cout_int);
		
        context.write(new Text(marque), new Text(new_value));
	}
}
