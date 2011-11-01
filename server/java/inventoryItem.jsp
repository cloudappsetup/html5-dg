<%!
public class inventoryItem {
		private String name;
		private String number;
		private int qty;
		private String taxamt;
		private float amt;
		private String desc;
		private String category;

		public inventoryItem(String name, String number, int qty,
				String taxamt, float amt, String desc, String category) {
			this.name = name;
			this.number = number;
			this.qty = qty;
			this.taxamt = taxamt;
			this.amt = amt;
			this.desc = desc;
			this.category = category;
		}
	}
%>