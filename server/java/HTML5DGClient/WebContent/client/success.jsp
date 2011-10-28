<%@ page language="java" import="net.sf.json.JSONObject"%>
<html>
<head>
<title>Thank you</title>
<jsp:include page="/pptransact">
	<jsp:param name="method" value="commitPayment" />
</jsp:include>
<script>
	function closeFlow() {
		parent.pptransact.releaseDG(<%=request.getAttribute("returnObj")%>
	);
	}
</script>

</head>
<body onload="closeFlow()">
	<div
		style="background-color: #FFF; height: 400px; width: 300px; border-radius: 8px; padding: 20px;">
		Thank you for the purchase!
		<button id="close" onclick="closeFlow();">close</button>
	</div>
</body>
</html>