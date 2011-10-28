package server.java.api;

import java.util.HashMap;

import server.java.data.InventoryItem;

public class InventoryService {

	private HashMap<String, InventoryItem> inventoryMap = null;

	public InventoryService() {
		inventoryMap = new HashMap<String, InventoryItem>();
	}

	public InventoryItem getInventoryItem(String itemId) {
		return inventoryMap.get(itemId);
	}

	public void addInventoryItem(InventoryItem item) {
		inventoryMap.put(item.getItemId(), item);
	}

	public void removeInventoryItem(String itemId) {
		inventoryMap.remove(itemId);
	}

	public void clearInventoryItems() {
		inventoryMap.clear();
	}

}
