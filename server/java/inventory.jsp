<%@ page language="java"%>
<%@ page language="java" import="java.util.HashMap"%>
<%@ include file="/server/java/inventoryItem.jsp"%>

<%!public HashMap<String, inventoryItem> inventoryMapT = null;

	public inventoryItem getInventoryItem(String itemId) {
		return inventoryMapT.get(itemId);
	}

	public HashMap<String, inventoryItem> getInventoryMap() {
		return this.inventoryMapT;
	}

	public void setInventoryMap(HashMap<String, inventoryItem> inventoryMap) {
		this.inventoryMapT = inventoryMap;
	}%>
