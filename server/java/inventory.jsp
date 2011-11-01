<%@ page language="java"%>
<%@ page language="java" import="java.util.HashMap"%>
<%@ include file="/server/java/inventoryItem.jsp"%>

<%! public void jspInit() {
		HashMap<String, inventoryItem> temp = new HashMap<String, inventoryItem>();
		temp.put("123", new inventoryItem("Mega Sheilds", "123", 1, "0", 1.00f,
				"Unlock the power!", "Digital"));
		temp.put("456", new inventoryItem("Laser Cannon", "456", 1, "0", 1.25f,
				"Lock and load!", "Digital"));
		setInventoryMap(temp);
	}
	public HashMap<String, inventoryItem> inventoryMapT = null;

	public inventoryItem getInventoryItem(String itemId) {
		return inventoryMapT.get(itemId);
	}

	public HashMap<String, inventoryItem> getInventoryMap() {
		return this.inventoryMapT;
	}

	public void setInventoryMap(HashMap<String, inventoryItem> inventoryMap) {
		this.inventoryMapT = inventoryMap;
	}
	
	
	%>
