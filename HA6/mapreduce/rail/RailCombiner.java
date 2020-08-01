package de.tuberlin.dbpra.mapreduce.rail;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class RailCombiner extends Reducer<Text, IntWritable, Text, IntWritable> {


	public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

		int sum = 0;

		for(IntWritable v : values){
			sum += v.get();
		}

		context.write(key, new IntWritable(sum));
	}
}
