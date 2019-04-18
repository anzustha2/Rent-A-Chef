package model;

import java.util.Date;

public class User {
	public int userId;
	public String userName;
	public String userTypeCode;
	public String userStatusCode;
	public String userStatusCodeDescription;
	public Date unblockDate;
	public boolean isIncorrectPassword;
	public String firstName;
	public String lastName;
	public String phoneNo;
	public String email;

	public User(int userId, String userName, String userTypeCode, String userStatusCode, Date unblockDate,
			boolean isIncorrectPassword, String userStatusCodeDescription, String firstName, String lastName,
			String phoneNo, String email) {
		this.userId = userId;
		this.userName = userName;
		this.userTypeCode = userTypeCode;
		this.userStatusCode = userStatusCode;
		this.userStatusCodeDescription = userStatusCodeDescription;
		this.unblockDate = unblockDate;
		this.isIncorrectPassword = isIncorrectPassword;
		this.firstName = firstName;
		this.lastName = lastName;
		this.phoneNo = phoneNo;
		this.email = email;
	}

	public boolean hasInvalidPassword() {
		return isIncorrectPassword;
	}

	public String getUserType() {
		// TODO Auto-generated method stub
		return userTypeCode;
	}
}
