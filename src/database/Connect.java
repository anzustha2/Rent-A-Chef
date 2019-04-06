
package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connect {
	public static Connection getConnection() throws SQLException {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/Rent_A_Chef_db?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String user = "student";
			String password = "student";
			conn = DriverManager.getConnection(url, user, password);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return conn;
	}

	public static void test() {
		try {
			Connection conn = getConnection();
			if (conn != null)
				System.out.println("Connection successful");
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}