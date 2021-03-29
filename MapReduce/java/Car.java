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
	
	public static void main(String[] args) throws Exception {
	
		Configuration conf = new Configuration();
		String[] ourArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
		Job job = Job.getInstance(conf, "CO2 MapReduce");

		// Definit les classes driver, map et reduce.
		job.setJarByClass(Car.class);
		job.setMapperClass(CarMap.class);
		job.setReducerClass(CarReduce.class);

		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
	
		FileInputFormat.addInputPath(job, new Path(ourArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(ourArgs[1]));

		if(job.waitForCompletion(true))
			System.exit(0);
		System.exit(-1);
	}
}
