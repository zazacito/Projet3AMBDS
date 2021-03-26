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
   
	
public class CarReduce extends Reducer<Text, Text, Text, Text> {
	
	
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
		
		String malus_bonus;
		String rejet;
		String cout;
		
		int sommeBonus_Malus = 0;
		int sommeRejet = 0;
		int sommeCout = 0;

		int count=0;
		int moyenneMalus_Bonus = 0;
		int moyenneRejet = 0;
		int moyenneCout = 0;

		Iterator<Text> i = values.iterator();
		while(i.hasNext()) {
			String node = i.next().toString(); 

			String[] splitted_node = node.split("\\|"); 
			malus_bonus = splitted_node[0];
			rejet = splitted_node[1];
			cout = splitted_node[2];

			sommeBonus_Malus += Integer.parseInt(malus_bonus);
			sommeRejet += Integer.parseInt(rejet);
			sommeCout += Integer.parseInt(cout);

			count++;
		}
		moyenneMalus_Bonus = sommeBonus_Malus/count;
		moyenneRejet = sommeRejet/count;
		moyenneCout = sommeCout/count;

		context.write(key, new Text(moyenneMalus_Bonus + "\t" + moyenneRejet + "\t" + moyenneCout));
	}
}
