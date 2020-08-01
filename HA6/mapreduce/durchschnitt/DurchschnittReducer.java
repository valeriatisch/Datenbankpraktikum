package de.tuberlin.dbpra.mapreduce.durchschnitt;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class DurchschnittReducer extends Reducer<Text, Text, Text, DoubleWritable> {

	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

		double anzahl_aller = 0.0;
		int counter = 0;

		for(Text v : values) {
			String line = v.toString();
			String[] array = line.split("\\|");
			anzahl_aller += Double.parseDouble(array[0]);
			if(array.length > 1) {
				counter += Integer.parseInt(array[1]);
			} else {
				counter++;
			}
		}

		context.write(key, new DoubleWritable(anzahl_aller / counter));

	}
}
