package model;

public class OrderItem {
	public int orderId;
	public int dishId;
	public String dishName;
	public String description;
	public String cuisineTypeCode;
	public String imagePath;
	public String videoPath;
	public Double estCost;
	public String unitTypeCode;
	public Double units;
	public Double estCostWithoutTax;
	public Double estTax;
	public String cuisineType;
	public String unitType;

	public OrderItem() {
		// TODO Auto-generated constructor stub
	}

	public OrderItem(int orderId, int dishId, String dishName, String description, String cuisineTypeCode,
			String imagePath, String videoPath, Double estCost, String unitTypeCode, Double units,
			Double estCostWithoutTax, Double estTax, String cuisineType, String unitType) {
		super();
		this.orderId = orderId;
		this.dishId = dishId;
		this.dishName = dishName;
		this.description = description;
		this.cuisineTypeCode = cuisineTypeCode;
		this.imagePath = imagePath;
		this.videoPath = videoPath;
		this.estCost = estCost;
		this.unitTypeCode = unitTypeCode;
		this.units = units;
		this.estCostWithoutTax = estCostWithoutTax;
		this.estTax = estTax;
		this.cuisineType = cuisineType;
		this.unitType = unitType;
	}

}
