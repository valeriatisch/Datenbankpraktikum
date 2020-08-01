package de.tuberlin.dbpra.mapreduce.rail;

import de.tuberlin.dbpra.mapreduce.durchschnitt.AufgabeDurchschnitt;
import de.tuberlin.dbpra.mapreduce.durchschnitt.DurchschnittMapper;
import de.tuberlin.dbpra.mapreduce.durchschnitt.DurchschnittReducer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;


public class AufgabeRail {

	public static void main(String[] args) throws Exception {
		if (args.length < 2) {
			throw new IllegalArgumentException("Usage: <input> <output>");
		}
		Configuration conf = new Configuration();
		String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
		Job job = new Job(conf, "AufgabeRail");
		job.setJarByClass(AufgabeRail.class);
		job.setMapperClass(RailMapper.class);
		job.setReducerClass(RailReducer.class);
		job.setCombinerClass(RailCombiner.class);
		job.setOutputKeyClass(IntWritable.class);
		job.setOutputValueClass(Text.class);
		TextInputFormat.addInputPath(job, new Path(otherArgs[0]));
		TextOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}

}
