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

// Notre classe MAP.
	// Les 4 types generiques correspondent a:
	// 1 - Object: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
public class CarMap extends Mapper<Object, Text, Text, Text> {
	
	// La fonction MAP.
		// Note: Le type du premier argument correspond au premier type generique.
		// Note: Le type du second argument correspond au deuxieme type generique.
		// Note: L'objet Context nous permet d'ecrire les couples (cle, valeur).
		
	protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		if (value.toString().contains("Marque")){ // pour ne pas prendre en compte la première ligne (en-tête)
			return;
		}

		String line = value.toString(); 
		line = line.replaceAll("\\u00a0"," ");
		
		String[] splitted_line = line.split(","); 

		// Gestion colonne marque
		String marque;
		String[] splitted_space = splitted_line[1].split("\\s+"); 
		marque = splitted_space[0];

		marque = marque.replace("\"", "");

		// Gestion colonne Malus/Bonus
        String malus_bonus = splitted_line[2];

		malus_bonus = malus_bonus.replaceAll(" ", "").replace("€1", "").replace("€", "").replace("\"", "");

		if (malus_bonus.equals("150kW(204ch)") || malus_bonus.equals("100kW(136ch)"))
		{
			return;
		}

		if (malus_bonus.length() == 1){
			malus_bonus="0"; 
		} 

		// Gestion colonne cout energie
        String cout;
 	    cout = splitted_line[4];
		String[] cout_splitted = cout.split(" ");
		if(cout_splitted.length == 2){  // ex : |967,€]
			cout = cout_splitted[0];
		} else if(cout_splitted.length == 3){ // ex : [1,005,€]
			cout= cout_splitted[0] + cout_splitted[1];
		}

		// Gestion colonne Rejet CO2
		String rejet = splitted_line[3];

		int malus_bonus_int = Integer.parseInt(malus_bonus);
		int rejet_int = Integer.parseInt(rejet);
		int cout_int = Integer.parseInt(cout);
	
		// couple clé/valeurs
		String new_value = String.valueOf(malus_bonus_int) + "|" +  String.valueOf(rejet_int) + "|" + String.valueOf(cout_int);
		
        context.write(new Text(marque), new Text(new_value));
	}
}