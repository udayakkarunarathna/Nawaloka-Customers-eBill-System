package com.model.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;

public class DatabaseConnection {

	public static int DbConnCount;
	Connection con;
	Statement stmt;
	ResultSet rs;
	DataSource ds;

	public void connectToDB() {
		// DB host
		String db_ip = "124.43.206.205";
		
		//System.out.println("db_ip = " + db_ip);
		// System.out.println("Trying to connect DB...");
		try {
			// step1 load the driver class
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// System.out.println("1");
		} catch (ClassNotFoundException e) {
			// System.out.println("ClassNotFoundException.....");
			e.printStackTrace();
		}
		try {
			// step2 create the connection object
			// System.out.println("2");
			con = DriverManager.getConnection("jdbc:oracle:thin:@" + db_ip + ":PORT:SERVICE", "DB_USER", "DB_PASSWORD");

			// step3 create the statement object
			stmt = con.createStatement();
			DbConnCount++;
		} catch (SQLException x) {
			// System.out.println("SQLException....");
			x.printStackTrace();
		}
	}

	public ResultSet query(String query) throws SQLException {
		rs = stmt.executeQuery(query);
		return rs;
	}

	public boolean InsertToDatabaseWithoutCommit(String query) {
		boolean result = false;
		try {
			stmt.executeUpdate(query);
			result = true;
		} catch (SQLException e) {
			result = false;
			// System.out.println("Error Inserting Data...");
		}
		return result;
	}

	public void SaveToDataBase(boolean bCommit) {
		try {
			if (bCommit) {
				con.commit();
			} else {
				con.rollback();
			}
		} catch (SQLException sqlexception) {
			// System.out.println("Error Commit Data...");
		}
	}

	public void flushStmtRs() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (con != null) {
				con.close();
				DbConnCount--;
				// System.out.println("");
			}
		} catch (SQLException sqlexception) {
			// System.out.println("Error Closing DataBase Connection");
		}
	}

	public boolean DirectInsertToDataBase(String query) throws SQLException {
		stmt.executeUpdate(query);
		con.commit();
		return true;
	}
}
