package de.tuberlin.dbpra.mapreduce.rail;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class RailReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

	@Override
	public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

		int sum = 0;

		// fuer jedes key-value-Paar, hol den Wert und add zu sum
		for(IntWritable v : values){
			sum += v.get();
		}

		// Schreibe jahr_monat und die Anzahl als key-value-Paar in den context
		context.write(key, new IntWritable(sum));

	}


}
