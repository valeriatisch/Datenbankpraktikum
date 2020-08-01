package de.tuberlin.dbpra.mapreduce.durchschnitt;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class DurchschnittMapper extends Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {

		String line = value.toString();
		String[] array = line.split("\\|");
		// 2. Feld einer Zeile
		String artikel = array[1];	// eig. Integer
		// 5. Feld einer Zeile
		String anzahl = array[4];	// eig. Decimal
		context.write(new Text(artikel), new Text(anzahl));
	}


}
