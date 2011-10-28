package server.java;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import server.java.api.DoExpressCheckout;
import server.java.api.GetTransactionDetails;
import server.java.api.InventoryService;
import server.java.api.SetExpressCheckout;
import server.java.data.CheckoutRequestObj;
import server.java.data.InventoryItem;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.paypal.sdk.core.nvp.NVPDecoder;
import com.paypal.sdk.exceptions.PayPalException;

public class pptransact extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static InventoryService inventoryService = null;
	private static final Log log = LogFactory.getLog(pptransact.class);

	public void init() {
		// initialize the inventory items.
		inventoryService = new InventoryService();
		inventoryService
				.addInventoryItem(new InventoryItem("123", "Mega Sheilds",
						1.00, 1, "Unlock the power!", "0.0", "Digital"));
		inventoryService.addInventoryItem(new InventoryItem("456",
				"Laser Cannon", 1.25, 1, "Lock and load!", "0.0", "Digital"));

	}

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		try {
			String method = request.getParameter("method");
			if (method.equals("getToken")) {
				doGetToken(request, response);
			} else if (method.equals("commitPayment")) {
				doCommitPayment(request, response);
			} else if (method.equals("verifyPayment")) {
				doVerifyPayment(request, response);
			}

		} catch (Exception e) {
			log.error(e);
		}

	}

	private String doCommitPayment(HttpServletRequest request,
			HttpServletResponse response) {
		log.info("Start function - doCommitPayment");
		try {
			JSONObject returnObj = new JSONObject();
			String[] userInfo = request.getParameter("data").split(",");
			CheckoutRequestObj ecRequestObj = new CheckoutRequestObj();
			ecRequestObj.setPayerId(request.getParameter("PayerID"));
			ecRequestObj.setPaymentType("Sale");
			ecRequestObj.setCurrencyCode("USD");
			ecRequestObj.setToken(request.getParameter("token"));
			ecRequestObj.setAmount(new Double(request.getParameter("amt")));
			NVPDecoder decoder = new NVPDecoder();
			decoder.decode(DoExpressCheckout.getInstance()
					.doExpressCheckoutCall(ecRequestObj));
			returnObj.put("transactionId",
					decoder.get("PAYMENTINFO_0_TRANSACTIONID"));
			returnObj.put("orderTime", decoder.get("PAYMENTINFO_0_ORDERTIME"));
			returnObj.put("paymentStatus",
					decoder.get("PAYMENTINFO_0_PAYMENTSTATUS"));
			returnObj.put("userId", userInfo[0]);
			returnObj.put("itemId", userInfo[1]);
			Identity.getInstance().recordPayment(returnObj);
			request.setAttribute("returnObj", returnObj.toString());
		} catch (Exception e) {
			log.error(e);
		}
		log.info("End function - doCommitPayment");
		return "";
	}

	private void doVerifyPayment(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		log.info("Start function - doVerifyPayment");
		JSONObject returnObj = new JSONObject();
		try {
			String userId = request.getParameter("userId");
			String itemId = request.getParameter("itemId");
			String transObj = request.getParameter("transactions");
			JSONArray x = JSONArray.fromObject(transObj);
			String transactionId = "";
			for (Object obj : x) {
				JSONObject obj1 = (JSONObject) obj;
				if (obj1.containsValue(itemId)) {
					transactionId = obj1.getString("transactionId");
					break;
				}
			}
			if (transactionId.equals("")) {
				returnObj.put("success", false);
				returnObj.put("error", "Item not found in transaction history");
				returnObj.put("state", "verifyPurchase");
				response.getWriter().print(returnObj.toString());
				return;
			}
			NVPDecoder transactionDecoder = new NVPDecoder();
			String transResponse = GetTransactionDetails.getInstance()
					.getTransactionDetailsCode(transactionId);
			transactionDecoder.decode(transResponse);
			String userTnxId = transactionDecoder.get("CUSTOM").split(",")[0];
			String itemTnxId = transactionDecoder.get("CUSTOM").split(",")[1];
			if (userId.equals(userTnxId) && itemId.equals(itemTnxId)) {
				returnObj.put("error", "");
				returnObj.put("success", true);
				returnObj.put("transactionId",
						transactionDecoder.get("TRANSACTIONID"));
				returnObj.put("orderTime", transactionDecoder.get("ORDERTIME"));
				returnObj.put("paymentStatus",
						transactionDecoder.get("PAYMENTSTATUS"));
				returnObj.put("itemId", itemId);
				returnObj.put("userId", userId);
			} else {
				returnObj.put("id", userId);
				returnObj.put("error", "Not a valid transaction for this user");
				returnObj.put("success", false);
				returnObj.put("state", "verifyPurchase");
			}

		} catch (Exception e) {
			log.error(e);
		}
		response.getWriter().print(returnObj.toString());
		log.info("End function - doVerifyPayment");

	}

	private void doGetToken(HttpServletRequest request,
			HttpServletResponse response) throws PayPalException, IOException {
		log.info("Start function - doGetToken");
		try {
			String userId = request.getParameter("userId");
			String itemId = request.getParameter("itemId");
			String qty = request.getParameter("qty");
			InventoryItem item = inventoryService.getInventoryItem(itemId);
			CheckoutRequestObj ecRequestObj = new CheckoutRequestObj();
			// Getting the server name and path from the request
			int index = request.getProtocol().indexOf("/");
			String protocol = request.getProtocol().substring(0, index);
			StringBuilder serverUrl = new StringBuilder();
			serverUrl.append(protocol.toLowerCase());
			serverUrl.append("://");
			serverUrl.append(request.getServerName());
			serverUrl.append(":");
			serverUrl.append(request.getServerPort());
			serverUrl.append(request.getContextPath());
			int iQty = Integer.parseInt(qty);
			double price = item.getItemPrice() * iQty;
			ecRequestObj.setAmount(price);
			ecRequestObj.setQty(iQty);
			ecRequestObj.setName(item.getItemName());
			ecRequestObj.setDesc(item.getItemDesc());
			ecRequestObj.setNumber(item.getItemId());
			ecRequestObj.setAmount0(item.getItemPrice());
			ecRequestObj.setShipDiscAmt("0");
			ecRequestObj.setShipmentAmt("0");
			ecRequestObj.setTaxAmt("0");
			ecRequestObj.setInsuranceAmt("0");
			ecRequestObj.setUserInfo(userId + "," + itemId);
			ecRequestObj.setCurrencyCode("USD");
			ecRequestObj.setPaymentType("Sale");
			NVPDecoder decoder = new NVPDecoder();
			StringBuilder strUrl = new StringBuilder();
			strUrl.append(serverUrl);
			strUrl.append("/client/success.jsp?amt=");
			strUrl.append(price);
			strUrl.append("&currencycode=");
			strUrl.append(ecRequestObj.getCurrencyCode());
			strUrl.append("&paymentaction=");
			strUrl.append(ecRequestObj.getPaymentType());
			strUrl.append("&data=");
			strUrl.append(userId);
			strUrl.append(",");
			strUrl.append(itemId);
			
			String paypalURL = "https://www.sandbox.paypal.com/incontext?token=";
			
			ecRequestObj.setReturnURL(strUrl.toString());
			
			ecRequestObj.setCancelURL(serverUrl.toString() + "/client/cancel.html");

			// Do SetEC call
			decoder.decode(SetExpressCheckout.getInstance()
					.setExpressCheckoutCall(ecRequestObj));
			JSONObject returnObj = new JSONObject();
			if (!decoder.get("ACK").equals("Success")) {
				String errorMsg = (decoder.get("L_ERRORCODE0") + decoder
						.get("L_LONGMESSAGE0"));
				returnObj.put("error", errorMsg);
			} else {
				String token = decoder.get("TOKEN");
				returnObj.put("redirecturl", paypalURL + token);
				returnObj.put("success", true);
			}
			response.getWriter().print(returnObj.toString());
		} catch (Exception e) {
			log.error(e);
		}
		log.info("End function - doGetToken");
		return;
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
