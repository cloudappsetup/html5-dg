package server.java.data;

public class InventoryItem {
	private String itemId;
	private String itemName;
	private double itemPrice;
	private int itemQuantity;
	private String itemDesc;
	private String itemTax;
	private String category;

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getItemDesc() {
		return itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public String getItemTax() {
		return itemTax;
	}

	public void setItemTax(String itemTax) {
		this.itemTax = itemTax;
	}

	public InventoryItem(String itemId, String itemName, double price,
			int itemQuantity, String itemDesc, String itemTax, String category) {
		super();
		this.itemId = itemId;
		this.itemName = itemName;
		this.itemPrice = price;
		this.itemQuantity = itemQuantity;
		this.itemDesc = itemDesc;
		this.itemTax = itemTax;
		this.category = category;
	}

	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public double getItemPrice() {
		return itemPrice;
	}

	public void setItemPrice(Float itemPrice) {
		this.itemPrice = itemPrice;
	}

	public int getItemQuantity() {
		return itemQuantity;
	}

	public void setItemQuantity(int itemQuantity) {
		this.itemQuantity = itemQuantity;
	}

}
