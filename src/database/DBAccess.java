package database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.User;

public class DBAccess {

	public static User JAK_SP_ProcessLogin(String userName, String password) {
		String sql = "{CALL JAK_SP_ProcessLogin(?, ?)}";
		User usr = null;
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, userName);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				usr = new User(rs.getInt(1), // userId
						userName, rs.getString(2), // userTypeCode
						rs.getString(3), // userTypeCode
						rs.getDate(4), // unblock date
						rs.getBoolean(5), // is incorrect password
						rs.getString(6) // user status description
				);
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usr;
	}
}
