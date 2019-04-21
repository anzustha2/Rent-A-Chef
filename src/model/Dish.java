package model;

import database.DBAccess;

public class Dish {
	public int dishId;
	public String name;
	public String description;
	public String cuisineTypeCode;
	public String imagePath;
	public String videoPath;
	public Double estCost;
	public String unitTypeCode;
	public Double baseUnits;
	public String cuisineDescription;
	public String unitDescription;

	public Dish() {

	}

	public Dish(int dishId, String name, String description, String cuisineTypeCode, String imagePath, String videoPath,
			Double estCost, String unitTypeCode, Double baseUnits, String cuisineDescription, String unitDescription) {
		super();
		this.dishId = dishId;
		this.name = name;
		this.description = description;
		this.cuisineTypeCode = cuisineTypeCode;
		this.imagePath = imagePath;
		this.videoPath = videoPath;
		this.estCost = estCost;
		this.unitTypeCode = unitTypeCode;
		this.baseUnits = baseUnits;
		this.cuisineDescription = cuisineDescription;
		this.unitDescription = unitDescription;
	}

	public String writeIngredients() {
		String val = "";
		java.util.List<Ingredient> ingredients = DBAccess.JAK_SP_GetDishIngredients(dishId);

		for (Ingredient i : ingredients) {
			if (!val.isEmpty()) {
				val += ", ";
			}
			val = val + i.ingredientName + " " + i.units + " " + i.unitType;
		}
		return val;
	}
}
