package de.tuberlin.dbpra.mapreduce.durchschnitt;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class DurchschnittCombiner extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

		double anzahl = 0.0;
		int zaehler = 0;

		for(Text v : values){
			String anzahl_string = v.toString();
			anzahl += Double.parseDouble(anzahl_string);
			zaehler++;
		}

		context.write(key, new Text(anzahl + "|" + zaehler));

	}
}

