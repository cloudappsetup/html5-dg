<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<cfscript>
	returnObj = StructNew();
	
	try {
		
		// COMMIT PAYMENT
		xconnect = createObject("component","/html5-dg/server/coldfusion/xconnect");
		returnObj = xconnect.commitPayment(url.userId,url.payerId,url.token,url.amt,url.itemId);	
	
	}

	catch(any e) 
	{
		writeOutput("Error: " & e.message);
		writeDump(responseStruct);
		abort;
	}
</cfscript>

<script>

function closeFlow() {
    parent.xconnection.releaseDG(<cfoutput>#returnObj#</cfoutput>);
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!
    <button id="close" onclick="closeFlow('null');">close</button>
</div>
</body>
</html>