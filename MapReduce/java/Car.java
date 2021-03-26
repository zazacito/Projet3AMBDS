package org.car;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;


// Classe Driver (contient le main du programme Hadoop).
public class Car {
	
// Le main du programme.
	public static void main(String[] args) throws Exception {
	
		// Cree un object de configuration Hadoop.
		Configuration conf = new Configuration();
		// Permet a Hadoop de lire ses arguments generiques, recupere les arguments restants dans ourArgs.
		String[] ourArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
		// Obtient un nouvel objet Job: une tache Hadoop. On fourni la configuration Hadoop ainsi qu'une description
		// textuelle de la tache.
		Job job = Job.getInstance(conf, "CO2 MapReduce");

		// Defini les classes driver, map et reduce.
		job.setJarByClass(Car.class);
		job.setMapperClass(CarMap.class);
		job.setReducerClass(CarReduce.class);

		// Defini types cle/valeurs de notre programme Hadoop.
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
	
		// Defini les fichiers d'entree du programme et le repertoire des resultats.
		// On se sert du premier et du deuxieme argument restants pour permettre a l'utilisateur de les specifier
		// lors de l'execution.
		FileInputFormat.addInputPath(job, new Path(ourArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(ourArgs[1]));

		// On lance la tache Hadoop. Si elle s'est effectuee correctement, on renvoie 0. Sinon, on renvoie -1.
		if(job.waitForCompletion(true))
			System.exit(0);
		System.exit(-1);
	}
}