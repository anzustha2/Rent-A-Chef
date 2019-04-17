package model;

public class Address {

	public int addressId;
	public int userId;
	public String address1;
	public String address2;
	public String city;
	public String state;
	public String zip;
	public String addressTypeCode;
	public String addressDescription;

	public Address(int addressId, int userId, String address1, String address2, String city, String state, String zip,
			String addressTypeCode, String addressDescription) {
		super();
		this.addressId = addressId;
		this.userId = userId;
		this.address1 = address1;
		this.address2 = address2;
		this.city = city;
		this.state = state;
		this.zip = zip;
		this.addressTypeCode = addressTypeCode;
		this.addressDescription = addressDescription;
	}

}
