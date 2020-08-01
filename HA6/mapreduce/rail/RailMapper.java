package de.tuberlin.dbpra.mapreduce.rail;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class RailMapper extends Mapper<LongWritable, Text, Text, IntWritable> {


	@Override
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {

		String line = value.toString();

		String[] array = line.split("\\|");

		String versandart = array[14];
		if (versandart.equals("RAIL")){	// per Zug
			double artikel_anzahl = Double.parseDouble(array[4]);
			String versanddatum = array[10];
			String jahr_monat = versanddatum.substring(0, 7);

			context.write(new Text(jahr_monat), new IntWritable((int) artikel_anzahl));
		}

	}

}
