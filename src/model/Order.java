package model;

public class Order {
	public int orderId;
	public int userId;
	public int chefId;
	public String createdTimestamp;
	public String expireDateTime;
	public String scheduledDateTime;
	public int scheduledAddressId;
	public String completionDate;
	public String pickedUpDateTime;
	public String orderStatusCode;
	public Double estCostWithoutTax;
	public Double estTax;
	public Double actualAmountWithoutTax;
	public Double actualTax;
	public String orderStatusDescription;

	public Order() {
		// TODO Auto-generated constructor stub
	}

	public Order(int orderId, int userId, int chefId, String createdTimestamp, String expireDateTime,
			String scheduledDateTime, int scheduledAddressId, String completionDate, String pickedUpDateTime,
			String orderStatusCode, Double estCostWithoutTax, Double estTax, Double actualAmountWithoutTax,
			Double actualTax, String orderStatusDescription) {
		super();
		this.orderId = orderId;
		this.userId = userId;
		this.chefId = chefId;
		this.createdTimestamp = createdTimestamp;
		this.expireDateTime = expireDateTime;
		this.scheduledDateTime = scheduledDateTime;
		this.scheduledAddressId = scheduledAddressId;
		this.completionDate = completionDate;
		this.pickedUpDateTime = pickedUpDateTime;
		this.orderStatusCode = orderStatusCode;
		this.estCostWithoutTax = estCostWithoutTax;
		this.estTax = estTax;
		this.actualAmountWithoutTax = actualAmountWithoutTax;
		this.actualTax = actualTax;
		this.orderStatusDescription = orderStatusDescription;
	}

}
