<%!
import net.sf.json.JSONObject;

public class Identity {

	private Identity() {

	}

	private volatile static Identity s_singleton = null;

	public static Identity getInstance() {
		if (s_singleton == null)
			s_singleton = new Identity();
		return s_singleton;
	}

	public String getUserId() {
		return "888888";

	}

	public boolean verifyUser(String userId) {
		String yourSessionUserId = "888888";
		return (userId.equals(yourSessionUserId)) ? true : false;
	}

	public void recordPayment(JSONObject paymentObj) {
		// INSERT YOUR CODE TO SAVE THE PAYMENT DATA
		//String userId = (String) paymentObj.get("userId");
		//String itemId = (String) paymentObj.get("itemId");
		//String transactionId = (String) paymentObj.get("transactionId");
		//String paymentStatus = (String) paymentObj.get("paymentStatus");
		//String orderTime = (String) paymentObj.get("orderTime");
	}

	public boolean verifyPayment(String userId, String paymentId) {
		// INSERT YOUR CODE TO QUERY PAYMENT DATA and RETURN TRUE if MATCH FOUND
		return false;
	}

	public void getPayment(String userId, String itemId) {
		// INSERT YOUR CODE TO QUERY PAYMENT DATA and RETURN PAYMENT STRUCTURE
		JSONObject returnObj = new JSONObject();
		returnObj.put("transactionId", "12345678");
		returnObj.put("orderTime", "2011-09-29T04:47:51Z");
		returnObj.put("success", true);
		returnObj.put("paymentStatus", "Pending");
		returnObj.put("error", "");
		returnObj.put("itemId", "123");
		returnObj.put("userId", "888888");
	}
}
%>