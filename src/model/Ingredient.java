package model;

public class Ingredient {
	public int ingredientId;
	public String ingredientName;
	public String description;
	public String imagePath;
	public String videoPath;
	public String unitTypeCode;
	public double units;
	public String unitType;

	public Ingredient(int ingredientId, String ingredientName, String description, String imagePath, String videoPath,
			String unitTypeCode, double units, String unitType) {
		super();
		this.ingredientId = ingredientId;
		this.ingredientName = ingredientName;
		this.description = description;
		this.imagePath = imagePath;
		this.videoPath = videoPath;
		this.unitTypeCode = unitTypeCode;
		this.units = units;
		this.unitType = unitType;
	}

	public Ingredient() {

	}

}
