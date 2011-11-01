<%@ page language="java" import="java.net.URLDecoder.*"%>
<%@ page language="java" import="net.sf.json.*"%>
<%@ page language="java" import="java.util.HashMap"%>
<%@ include file="/server/java/inventory.jsp"%>
<%@ include file="/server/java/common.jsp"%>
<%!
	private String doCommitPayment(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			JSONObject returnObj = new JSONObject();
			String[] userInfo = request.getParameter("data").split(",");
			StringBuilder data = new StringBuilder();
			data.append("&TOKEN=");
			data.append(request.getParameter("token"));
			data.append("&PAYERID=");
			data.append(request.getParameter("PayerID"));
			data.append("&AMT=");
			data.append(request.getParameter("amt"));
			data.append("&PAYMENTACTION=Sale");
			data.append("&CURRENCYCODE=USD");

			HashMap decoder = httpcall("DoExpressCheckoutPayment",
					data.toString());

			returnObj.put("transactionId",
					decoder.get("PAYMENTINFO_0_TRANSACTIONID"));
			returnObj.put("orderTime", decoder.get("PAYMENTINFO_0_ORDERTIME"));
			returnObj.put("paymentStatus",
					decoder.get("PAYMENTINFO_0_PAYMENTSTATUS"));
			returnObj.put("userId", userInfo[0]);
			returnObj.put("itemId", userInfo[1]);

			request.setAttribute("returnObj", returnObj.toString());
		} catch (Exception e) {

		}

		return "";
	}

	private void doVerifyPayment(HttpServletRequest request,
			HttpServletResponse response) {

		try {
			JSONObject returnObj = new JSONObject();
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
			StringBuilder data = new StringBuilder();
			data.append("&TRANSACTIONID=");
			data.append(transactionId);

			HashMap transactionDecoder = httpcall("GetTransactionDetails",
					data.toString());

			String userTnxId = transactionDecoder.get("CUSTOM").toString()
					.split(",")[0];
			String itemTnxId = transactionDecoder.get("CUSTOM").toString()
					.split(",")[1];
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
			response.getWriter().print(returnObj.toString());
		} catch (Exception e) {

		}

	}

	private void doGetToken(HttpServletRequest request,
			HttpServletResponse response) {

		try {
			String userId = request.getParameter("userId");
			String itemId = request.getParameter("itemId");
			String qty = request.getParameter("qty");

			inventoryItem item = getInventoryItem(itemId);

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
			float amt = item.amt * iQty;
			StringBuilder strUrl = new StringBuilder();
			strUrl.append(serverUrl);
			strUrl.append("/server/java/success.jsp?amt=");
			strUrl.append(amt);
			strUrl.append("&currencycode=");
			strUrl.append("USD");
			strUrl.append("&paymentaction=");
			strUrl.append("Sale");
			strUrl.append("&data=");
			strUrl.append(userId);
			strUrl.append(",");
			strUrl.append(itemId);
			StringBuilder data = new StringBuilder();
			data.append("&PAYMENTREQUEST_0_CURRENCYCODE=USD&PAYMENTREQUEST_0_AMT=");
			data.append(amt);
			data.append("&PAYMENTREQUEST_0_TAXAMT=0&PAYMENTREQUEST_0_DESC=JS Wars");
			data.append("&PAYMENTREQUEST_0_PAYMENTACTION=Sale");
			data.append("&L_PAYMENTREQUEST_0_ITEMCATEGORY0=");
			data.append(item.category);
			data.append("&L_PAYMENTREQUEST_0_NAME0=");
			data.append(item.name);
			data.append("&L_PAYMENTREQUEST_0_NUMBER0=");
			data.append(item.number);
			data.append("&L_PAYMENTREQUEST_0_QTY0=");
			data.append(item.qty);
			data.append("&L_PAYMENTREQUEST_0_TAXAMT0=0");
			data.append("&L_PAYMENTREQUEST_0_AMT0=");
			data.append(item.amt);
			data.append("&L_PAYMENTREQUEST_0_DESC0=");
			data.append(item.desc);
			data.append("&PAYMENTREQUEST_0_SHIPPINGAMT=0");
			data.append("&PAYMENTREQUEST_0_SHIPDISCAMT=0");
			data.append("&PAYMENTREQUEST_0_TAXAMT=0");
			data.append("&PAYMENTREQUEST_0_INSURANCEAMT=0");
			data.append("&PAYMENTREQUEST_0_PAYMENTACTION=sale");
			data.append("&L_PAYMENTTYPE0=sale");
			data.append("&PAYMENTREQUEST_0_CUSTOM=");
			data.append(userId);
			data.append(",");
			data.append(item.number);
			data.append("&ReturnUrl=");
			data.append(URLEncoder.encode(strUrl.toString()));
			data.append("&CANCELURL=");
			data.append(URLEncoder.encode(serverUrl.toString()
					+ "/server/java/cancel.jsp"));

			HashMap decoder = httpcall("SetExpressCheckout", data.toString());
			String strAck = decoder.get("ACK").toString();

			String paypalURL = "https://www.sandbox.paypal.com/incontext?token=";

			JSONObject returnObj = new JSONObject();
			if (!decoder.get("ACK").equals("Success")) {
				String errorMsg = (decoder.get("L_ERRORCODE0").toString() + decoder
						.get("L_LONGMESSAGE0").toString());
				returnObj.put("error", errorMsg);
			} else {
				String token = decoder.get("TOKEN").toString();
				returnObj.put("redirecturl", paypalURL + token);
				returnObj.put("success", true);
			}
			response.getWriter().print(returnObj.toString());
		} catch (Exception e) {

		}

	}%>

<%
	String method = request.getParameter("method");
	if (method.equals("getToken")) {
		doGetToken(request, response);
	} else if (method.equals("commitPayment")) {
		doCommitPayment(request, response);
	} else if (method.equals("verifyPayment")) {
		doVerifyPayment(request, response);
	}
%>
