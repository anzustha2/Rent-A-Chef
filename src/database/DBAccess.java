package database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.Hashtable;
import java.util.List;

import model.Address;
import model.Dish;
import model.Ingredient;
import model.Order;
import model.OrderItem;
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
						rs.getString(6), // user status description
						rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usr;
	}

	public static List<Ingredient> JAK_SP_GetDishIngredients(int dishId) {
		String sql = "{CALL JAK_SP_GetDishIngredients(?)}";
		Connection conn = null;
		List<Ingredient> allIngredients = new ArrayList<Ingredient>();
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, dishId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				allIngredients.add(new Ingredient(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getString(6), rs.getDouble(7), rs.getString(8)));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allIngredients;
	}

	public static List<Dish> JAK_SP_GetDishes(String cuisineTypeCode) {
		String sql = "{CALL JAK_SP_GetDishes(?)}";
		Connection conn = null;
		List<Dish> allDishes = new ArrayList<Dish>();
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cuisineTypeCode);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				allDishes.add(new Dish(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5),
						rs.getString(6), rs.getDouble(7), rs.getString(8), rs.getDouble(9), rs.getString(10),
						rs.getString(11)));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allDishes;
	}

	public static Dish JAK_SP_GetDish(int dishId) {
		String sql = "{CALL JAK_SP_GetDish(?)}";
		Connection conn = null;
		Dish dish = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, dishId);
			ResultSet rs = ps.executeQuery();
			while (rs.next())
				dish = new Dish(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5),
						rs.getString(6), rs.getDouble(7), rs.getString(8), rs.getDouble(9), rs.getString(10),
						rs.getString(11));

			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dish;
	}

	public static Dictionary<String, String> JAK_SP_GetOptions(String optionTypeCode) {
		Dictionary<String, String> options = new Hashtable<String, String>();
		String sql = "{CALL JAK_SP_GetOptions(?)}";
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, optionTypeCode);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				options.put(rs.getString(1), rs.getString(2));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return options;
	}

	public static void JAK_SP_RemoveOrderItem(int orderId, int dishId) {
		String sql = "{CALL JAK_SP_RemoveOrderItem(?, ?)}";
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ps.setInt(2, dishId);
			ResultSet rs = ps.executeQuery();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static List<Address> JAK_SP_GetUserAddress(int userId) {
		String sql = "{CALL JAK_SP_GetUserAddress(?)}";
		Connection conn = null;
		List<Address> allAddresses = new ArrayList<Address>();
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {

				allAddresses.add(new Address(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9)));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allAddresses;
	}

	public static Address JAK_SP_GetAddress(int addressId) {
		String sql = "{CALL JAK_SP_GetAddress(?)}";
		Connection conn = null;
		Address newAddress = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, addressId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				newAddress = new Address(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getString(5),
						rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return newAddress;
	}

	public static Address JAK_SP_AddUserAddress(int userId, String address1, String address2, String city, String state,
			String zip, String addressTypeCode) {
		String sql = "{CALL JAK_SP_AddUserAddress(?, ?, ?, ?, ?, ?, ?)}";
		Connection conn = null;
		int newAddressId = 0;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			ps.setString(2, address1);
			ps.setString(3, address2);
			ps.setString(4, city);
			ps.setString(5, state);
			ps.setString(6, zip);
			ps.setString(7, addressTypeCode);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				newAddressId = rs.getInt(1);
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return JAK_SP_GetAddress(newAddressId);
	}

	public static int JAK_SP_CreateOrder(int userId, int addressId, java.sql.Date expireDateTime,
			java.sql.Date scheduledDateTime) {
		String sql = "{CALL JAK_SP_CreateOrder(?, ?, ?, ?)}";
		Connection conn = null;
		int newOrderId = 0;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			ps.setInt(2, addressId);
			ps.setDate(3, expireDateTime);
			ps.setDate(4, scheduledDateTime);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				newOrderId = rs.getInt(1);
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return newOrderId;
	}

	public static void JAK_SP_UpdateOrder(int orderId, int chefId, String expireDateTime, String scheduledDateTime,
			int addressId, String completionDateTime, String pickedUpDateTime, String orderStatusCode,
			Double estCostWithoutTax, Double estTax, Double actualAmountWithoutTax, Double actualTax) {
		String sql = "{CALL JAK_SP_UpdateOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  )}";
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ps.setInt(2, chefId);
			ps.setString(3, expireDateTime.toString());
			ps.setString(4, scheduledDateTime.toString());
			ps.setInt(5, addressId);
			ps.setString(6, completionDateTime.toString());
			ps.setString(7, pickedUpDateTime.toString());
			ps.setString(8, orderStatusCode);
			ps.setDouble(9, estCostWithoutTax);
			ps.setDouble(10, estTax);
			ps.setDouble(11, actualAmountWithoutTax);
			ps.setDouble(12, actualTax);
			ps.executeQuery();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void JAK_SP_AddOrderItem(int orderId, int dishId, String unitTypeCode, Double units,
			Double estCostWithoutTax, Double estTax) {
		String sql = "{CALL JAK_SP_AddOrderItem(?, ?, ?, ?, ?, ?)}";
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ps.setInt(2, dishId);
			ps.setString(3, unitTypeCode);
			ps.setDouble(4, units);
			ps.setDouble(5, estCostWithoutTax);
			ps.setDouble(6, estTax);
			ps.executeQuery();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void JAK_SP_updateOrderItem(int orderId, int dishId, String unitTypeCode, Double units,
			Double estCostWithoutTax, Double estTax) {
		String sql = "{CALL JAK_SP_updateOrderItem(?, ?, ?, ?, ?, ?)}";
		Connection conn = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ps.setInt(2, dishId);
			ps.setString(3, unitTypeCode);
			ps.setDouble(4, units);
			ps.setDouble(5, estCostWithoutTax);
			ps.setDouble(6, estTax);
			ps.executeQuery();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// userId=0 will return all; Order_Status='OP','EXP','COMP','INV','IP','PU'
	public static List<Order> JAK_SP_GetOrders(int userId, String orderStatusCode) {
		String sql = "{CALL JAK_SP_GetOrders(?, ?)}";
		Connection conn = null;
		List<Order> allOrders = new ArrayList<Order>();
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			ps.setString(2, orderStatusCode);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				allOrders.add(new Order(rs.getInt(1), rs.getInt(2), rs.getInt(3), rs.getDate(4), rs.getDate(5),
						rs.getDate(6), rs.getInt(7), rs.getDate(8), rs.getDate(9), rs.getString(10), rs.getDouble(11),
						rs.getDouble(12), rs.getDouble(13), rs.getDouble(14), rs.getString(15)));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allOrders;
	}

	// userId=0 will return all; Order_Status='OP','EXP','COMP','INV','IP','PU'
	public static Order JAK_SP_GetOrder(int orderId) {
		String sql = "{CALL JAK_SP_GetOrder(?)}";
		Connection conn = null;
		Order order = null;
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				order = new Order(rs.getInt(1), rs.getInt(2), rs.getInt(3), rs.getDate(4), rs.getDate(5), rs.getDate(6),
						rs.getInt(7), rs.getDate(8), rs.getDate(9), rs.getString(10), rs.getDouble(11),
						rs.getDouble(12), rs.getDouble(13), rs.getDouble(14), rs.getString(15));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return order;
	}

	public static List<OrderItem> JAK_SP_GetOrderItems(int orderId) {
		String sql = "{CALL JAK_SP_GetOrderItems(?)}";
		Connection conn = null;
		List<OrderItem> allOrders = new ArrayList<OrderItem>();
		try {
			conn = Connect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {

				allOrders.add(new OrderItem(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getString(6), rs.getString(7), rs.getDouble(8), rs.getString(9),
						rs.getDouble(10), rs.getDouble(11), rs.getDouble(12), rs.getString(13), rs.getString(14)));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allOrders;
	}
}
