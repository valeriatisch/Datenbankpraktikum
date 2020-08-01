package de.tuberlin.dima.dbpra.exercises;

import de.tuberlin.dima.dbpra.interfaces.SQL5ExercisesInterface;
import de.tuberlin.dima.dbpra.interfaces.transactions.Bestellposten;
import de.tuberlin.dima.dbpra.interfaces.transactions.Bestellung;
import de.tuberlin.dima.dbpra.interfaces.transactions.Lieferant;
import de.tuberlin.dima.dbpra.interfaces.transactions.LiefertEntry;

import javax.naming.spi.ResolveResult;
import java.sql.*;
import java.util.Iterator;

public class TransactionsExercises implements SQL5ExercisesInterface {

	public void bestellungBearbeiten(Connection connection, Bestellung bestellung) {

		if (bestellung == null)
			return;

		try {
			connection.setAutoCommit(false);
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
			Statement statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);

			double gesamtpreis = 0.0;

			PreparedStatement ps_bestellung_einfuegen = connection.prepareStatement("INSERT INTO BESTELLUNG VALUES (?, ?, ?, ?, CURRENT_DATE, ?, ?, ?)");
			ps_bestellung_einfuegen.setInt(1, bestellung.getBestell_Nr());
			ps_bestellung_einfuegen.setInt(2, bestellung.getKunde());
			ps_bestellung_einfuegen.setString(3, bestellung.getStatus());
			ps_bestellung_einfuegen.setDouble(4, gesamtpreis);
			ps_bestellung_einfuegen.setString(5, bestellung.getBestellprioritaet());
			ps_bestellung_einfuegen.setString(6, bestellung.getBearbeiter());
			ps_bestellung_einfuegen.setInt(7, bestellung.getVersandprioritaet());
			ps_bestellung_einfuegen.execute();

			if(bestellung.getBestellposten() == null) {
				connection.rollback();
				return;
			}

			Iterator<Bestellposten> posten = bestellung.getBestellposten();

			while (posten.hasNext()) {
				Bestellposten bestellposten = posten.next();

				if (bestellposten == null) {
					connection.rollback();
					return;
				}

				ResultSet liefert = statement.executeQuery("SELECT * FROM LIEFERT WHERE ARTIKEL = " + bestellposten.getArtikel()
						+ " AND ANZAHL_VERFUEGB >= " + bestellposten.getAnzahl() + " ORDER BY LIEFERPREIS FETCH FIRST 1 ROWS ONLY");

				if (!liefert.next()) {
					connection.rollback();
					return;
				}

				double preis = liefert.getDouble(4) * bestellposten.getAnzahl() + 1.0;
				gesamtpreis += preis;

				PreparedStatement ps_bestellposten_einfuegen = connection.prepareStatement("INSERT INTO BESTELLPOSTEN VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				ps_bestellposten_einfuegen.setInt(1, bestellung.getBestell_Nr());
				ps_bestellposten_einfuegen.setString(2, bestellposten.getArtikel());
				ps_bestellposten_einfuegen.setInt(3, liefert.getInt(2));
				ps_bestellposten_einfuegen.setInt(4, bestellposten.getPostennummer());
				ps_bestellposten_einfuegen.setDouble(5, bestellposten.getAnzahl());
				ps_bestellposten_einfuegen.setDouble(6, preis);
				ps_bestellposten_einfuegen.setDouble(7, 0.0);
				ps_bestellposten_einfuegen.setDouble(8, 0.0);
				ps_bestellposten_einfuegen.setString(9, bestellposten.getRetourstatus());
				ps_bestellposten_einfuegen.setString(10, bestellposten.getPostenstatus());
				ps_bestellposten_einfuegen.setDate(11, Date.valueOf(bestellposten.getVersanddatum()));
				ps_bestellposten_einfuegen.setDate(12, Date.valueOf(bestellposten.getBestaetigungsdatum()));
				ps_bestellposten_einfuegen.setDate(13, Date.valueOf(bestellposten.getEmpfangsdatum()));
				ps_bestellposten_einfuegen.setString(14, bestellposten.getVersandanweisung());
				ps_bestellposten_einfuegen.setString(15, bestellposten.getVersandart());
				ps_bestellposten_einfuegen.executeUpdate();

				PreparedStatement ps3 = connection.prepareStatement("UPDATE LIEFERT SET ANZAHL_VERFUEGB = ANZAHL_VERFUEGB - " + bestellposten.getAnzahl() + " WHERE ARTIKEL = " + bestellposten.getArtikel() + " AND LIEFERANT = " + liefert.getInt(2));
				ps3.executeUpdate();
			}

			statement.executeUpdate("UPDATE BESTELLUNG SET GESAMTPREIS = " + gesamtpreis + " WHERE BESTELL_NR = " + bestellung.getBestell_Nr());

			connection.commit();

		} catch (SQLException throwables) {
			throwables.printStackTrace();
			try {
				connection.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}

	}

	public void neueLieferdatenEinfuegen(Connection connection,  Lieferant lieferant) {

		if(lieferant == null)
			return;

		try {
			connection.setAutoCommit(false);
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
			Statement statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);

			ResultSet liefert = statement.executeQuery("SELECT * FROM LIEFERANT WHERE LIEFERANTEN_NR = " + lieferant.getLieferanten_nr());
			//printResult(liefert);

			boolean bestehend = false;
			double old_avg_preis_var = 0.0;
			//bestehender Lieferant
			if(liefert.next()){
				bestehend = true;
				//System.out.println("Bestehender Lieferant 1");
				ResultSet avg_preis_set = statement.executeQuery("SELECT AVG(LIEFERPREIS) FROM LIEFERT WHERE LIEFERANT = " + lieferant.getLieferanten_nr());
				avg_preis_set.next();
				old_avg_preis_var = avg_preis_set.getDouble(1);
				//System.out.println("Durchschnittlicher Lieferpreis des bestehenden Lieferanten aller Artikel: " + old_avg_preis_var);
			} else {
				//neuer Lieferant
				//System.out.println("Neuer Lieferant");
				PreparedStatement ps_insert_new_lieferant = connection.prepareStatement("INSERT INTO LIEFERANT VALUES(?, ?, ?, ?, ?, ?)");
				ps_insert_new_lieferant.setInt(1, lieferant.getLieferanten_nr());
				ps_insert_new_lieferant.setString(2, lieferant.getName());
				ps_insert_new_lieferant.setString(3, lieferant.getAdresse());
				ps_insert_new_lieferant.setInt(4, lieferant.getLand());
				ps_insert_new_lieferant.setString(5, lieferant.getTelefon());
				ps_insert_new_lieferant.setDouble(6, lieferant.getKontostand());
				ps_insert_new_lieferant.execute();
			}

			int artikel_counter = 0;
			double preis_summe = 0.0;

			Iterator<LiefertEntry> angebot = lieferant.getLiefertEntries();

			while (angebot.hasNext()) {
				LiefertEntry entry = angebot.next();

				if(entry == null){
					connection.rollback();
					return;
				}

				//bestehender Lieferant
				if(bestehend) {
					//System.out.println("Bestehender Lieferant 2");
					artikel_counter++;
					preis_summe += entry.getPreis();

					ResultSet artikel_set = statement.executeQuery("SELECT ARTIKEL FROM LIEFERT WHERE ARTIKEL = " + entry.getArtikel() + " AND LIEFERANT = " + lieferant.getLieferanten_nr() + " AND ANZAHL_VERFUEGB >= " + entry.getAnzahl());
					//neue Artikelmenge ist weniger oder gleich
					if (artikel_set.next()) {
						//System.out.println("Neue Artikelmenge ist weniger oder gleich");
						connection.rollback();
						return;
					}

					statement.executeUpdate("UPDATE LIEFERT SET ANZAHL_VERFUEGB = " + entry.getAnzahl() + " , LIEFERPREIS = " + entry.getPreis() +
							" WHERE ARTIKEL = " + entry.getArtikel() + " AND LIEFERANT = " + lieferant.getLieferanten_nr());

				} else {
					//neuer Lieferant
					//System.out.println("Neuer Lieferant");
					ResultSet avg_preis_set = statement.executeQuery("SELECT AVG(LIEFERPREIS) FROM LIEFERT WHERE ARTIKEL = " + entry.getArtikel());
					avg_preis_set.next();
					if(entry.getPreis() > avg_preis_set.getDouble(1) * 1.1){
						//System.out.println("Artikel sind zu teuer.");
						connection.rollback();
						return;
					}

					PreparedStatement ps_insert_new_liefert = connection.prepareStatement("INSERT INTO LIEFERT VALUES(?, ?, ?, ?)");
					ps_insert_new_liefert.setInt(1, Integer.parseInt(entry.getArtikel()));
					ps_insert_new_liefert.setInt(2, lieferant.getLieferanten_nr());
					ps_insert_new_liefert.setInt(3, entry.getAnzahl());
					ps_insert_new_liefert.setDouble(4, entry.getPreis());
					ps_insert_new_liefert.execute();
				}

			}

			//bestehender Lieferant
			if(bestehend) {
				//System.out.println("Bestehender Lieferant 3");
				double neu_avg_preis_var = preis_summe / artikel_counter;
				//System.out.println("Neuer Durchschnittspreis " + neu_avg_preis_var);
				// new avg price is too high
				if (neu_avg_preis_var > old_avg_preis_var * 1.1) {
					//System.out.println("Artikel zu teuer");
					connection.rollback();
					return;
				}
			}

			connection.commit();

		} catch (SQLException throwables) {
			throwables.printStackTrace();
			try {
				connection.rollback();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

	}

}
