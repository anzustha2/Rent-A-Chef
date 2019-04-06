package model;

import java.util.Date;

public class User {
	private int userId;
	private String userName;
	private String userTypeCode;
	private String userStatusCode;
	private String userStatusCodeDescription;
	private Date unblockDate;
	private boolean isIncorrectPassword;

	public User(int userId, String userName, String userTypeCode, String userStatusCode, Date unblockDate,
			boolean isIncorrectPassword, String userStatusCodeDescription) {
		this.userId = userId;
		this.userName = userName;
		this.userTypeCode = userTypeCode;
		this.userStatusCode = userStatusCode;
		this.userStatusCodeDescription = userStatusCodeDescription;
		this.unblockDate = unblockDate;
		this.isIncorrectPassword = isIncorrectPassword;
	}

	public boolean hasInvalidPassword() {
		return isIncorrectPassword;
	}

	public String getUserType() {
		// TODO Auto-generated method stub
		return userTypeCode;
	}
}
