<cfcomponent>
	<cfscript>
		
		// create our objects to call methods on
		caller = createObject("component","/html5-dg/server/coldfusion/lib/services/CallerService");
		ec = createObject("component","/html5-dg/server/coldfusion/lib/ExpressCheckout");
		identity = createObject('component','/html5-dg/server/coldfusion/identity');
		inventory = createObject('component','/html5-dg/server/coldfusion/inventory');
		
	</cfscript>
 
   <cffunction name="getToken" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" required="yes">
        <cfargument name="qty" type="string" required="yes">
	
		<cfset var result = "">
        
        <cfscript>
	
			var returnObj = StructNew();
		
			var itemObj = StructNew();
			itemObj = inventory.getItemDetails(arguments.itemId);
			itemObj['qty'] = arguments.qty;
	
			
			if (identity.verifyUser(arguments.userId))
				{	
				try {	
					data = StructNew();
					data.METHOD = "SetExpressCheckout";
					
					data.PAYMENTREQUEST_0_CURRENCYCODE="USD";
					data.PAYMENTREQUEST_0_AMT=(itemObj.qty * itemObj.amt);
					data.PAYMENTREQUEST_0_TAXAMT="0";
					
					data.PAYMENTREQUEST_0_DESC="Canvas Wars";
					data.PAYMENTREQUEST_0_PAYMENTACTION="Sale";
					
					data.L_PAYMENTREQUEST_0_ITEMCATEGORY0=itemObj.category;
					data.L_PAYMENTREQUEST_0_NAME0=itemObj.name;
					data.L_PAYMENTREQUEST_0_NUMBER0=itemObj.number;
					data.L_PAYMENTREQUEST_0_QTY0=itemObj.qty;
					data.L_PAYMENTREQUEST_0_TAXAMT0="0";
					data.L_PAYMENTREQUEST_0_AMT0=itemObj.amt;
					data.L_PAYMENTREQUEST_0_DESC0=itemObj.desc;
					
					FORM.currencyCodeType = "USD";
				
					FORM.ITEMCNT = 1;
					PAYMENTREQUEST_0_SHIPPINGAMT = "0";
					PAYMENTREQUEST_0_SHIPDISCAMT = "0";
					PAYMENTREQUEST_0_TAXAMT = "0";
					PAYMENTREQUEST_0_INSURANCEAMT = "0";
					PAYMENTREQUEST_0_PAYMENTACTION = "sale";
					L_PAYMENTTYPE0 = "sale";
				
					data.PAYMENTREQUEST_0_CUSTOM = arguments.userId & ',' & itemObj.number;
					
					// set url info
					data.serverName = SERVER_NAME;
					data.serverPort = CGI.SERVER_PORT;
					data.contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
					data.protocol = CGI.SERVER_PROTOCOL;
					data.cancelPage = "cancel.cfm";
					data.returnPage = "success.cfm?userId=" & URLEncodedFormat(arguments.userId) & '&itemId=' & URLEncodedFormat(arguments.itemId);
					
					requestData = ec.setExpressCheckoutData(form,request,data);
					
					response = caller.doHttppost(requestData);
					
					responseStruct = caller.getNVPResponse(#URLDecode(response)#);
					
				
					if (responseStruct.Ack is not "Success")
					{
						Throw(type="InvalidData",message="Response:#responseStruct.Ack#, ErrorCode: #responseStruct.L_ERRORCODE0#, Message: #responseStruct.L_LONGMESSAGE0#"); 	
					
					} else {
						token = responseStruct.token;
					}
					
					/*	cfhttp.FileContent returns token and other response value from the server.
					We need to pass token as parameter to destination URL which redirect to return URL
					*/
					redirecturl = request.PayPalURL & token;
					
					returnObj['success'] = true;
					returnObj['redirecturl'] = redirecturl;	
					
				}
				
				catch(any e) 
				{
					returnObj['success'] = true;
					returnObj['error'] = e.message;
				}
			} 
			
		
			return serializeJSON(returnObj);
		</cfscript>

	</cffunction>
    
    <cffunction name="commitPayment" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="payerId" type="string" required="yes">
        <cfargument name="token" type="string" required="yes">
        <cfargument name="amt" type="string" required="yes">
        <cfargument name="itemId" type="string" required="yes">
	
        <cfscript>
            responseStruct = StructNew();
            returnObj = StructNew();
         
		 
			if (identity.verifyUser(arguments.userId))
				{	
			
				try {
		
					// DOEXPRESSCHECKOUTPAYMENT
					var data = StructNew();
					data.method = "DoExpressCheckoutPayment";
					data.token = arguments.token;
					data.amt = arguments.amt;
					data.payerid = arguments.payerid;
					data.paymentAction = "sale";
			
					requestData = ec.setGetCheckoutData(request,data);
					
					response = caller.doHttppost(requestData);
					responseStruct = caller.getNVPResponse(#URLDecode(response)#);
				
					returnObj['transactionId'] = responseStruct.PAYMENTINFO_0_TRANSACTIONID;
					returnObj['orderTime'] = responseStruct.PAYMENTINFO_0_ORDERTIME;
					returnObj['paymentStatus'] = responseStruct.PAYMENTINFO_0_PAYMENTSTATUS;
					returnObj['itemId'] = arguments.itemId;
					returnObj['userId'] = arguments.userId;
					
					// save copy of payment on your server (optional)
					identity.recordPayment(returnObj);	
			
				
				}
			
				catch(any e) 
				{
					writeOutput("Error: " & e.message);
					writeDump(responseStruct);
					abort;
				}
			
        
    	    }
        </cfscript>
        
    	
    	<cfreturn serializeJSON(returnObj)>
    </cffunction>
    
    <cffunction name="verifyPayment" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" default="0" required="yes">
        <cfargument name="transactions" type="any" required="no">
		
		<cfset var tnx = DeserializeJSON(arguments.transactions,true)>
		<cfset var returnObj = StructNew()>
        <cfset returnObj['success'] = false>
		<cfset returnObj['error'] = 'User or Item not found in transaction history'>
     
		<cfset var transactionId = '0'>
	
       
		<cfif isArray(tnx) >
             <cfloop from="1" to="#ArrayLen(tnx)#" index="i">
                <cfif tnx[i]['itemId'] eq arguments.itemId>
                    <cfset transactionId = tnx[i]['transactionId']>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        
		
		<cfscript>
		
		if (identity.verifyUser(arguments.userId))
			{	
				
			try {	
			
				if(transactionId neq 0)
				{
					returnObj = getTransactionDetails(arguments.userId,arguments.itemId,transactionId);
				} else {
					
					// LOCAL STORAGE TRANSACTION ID NOT FOUND TRY TO VERIFY ON DEVELOPER SERVER
					if (identity.verifyPayment(arguments.userId,arguments.itemId))
					{
						returnObj = identity.getPayment(arguments.userId,arguments.itemId);
					
					// VERIFICATION ON DEVELOPER RECORDED PAYMENTS FAIL
					} else {
						returnObj['success'] = false;
						returnObj['error'] = 'Item not found in transaction history';
					}
				}
			}
			
			catch(any e) 
			{
				returnObj['success'] = false;
				returnObj['error'] = e.message;
			}
						
		}
		
		return serializeJSON(returnObj);
		</cfscript>
    	
    </cffunction>
    
    
     <cffunction name="getTransactionDetails" access="private" returntype="struct" >
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" default="0" required="yes">
        <cfargument name="transactionId" type="string" default="0" required="yes">
  
  		<cfscript>
    		data = StructNew();
			data.method = "GetTransactionDetails";
			data.transactionid = transactionId;
	
			requestData = ec.setGetCheckoutData(request,data);
			
			response = caller.doHttppost(requestData);
			responseStruct = StructNew();
			responseStruct = caller.getNVPResponse(#URLDecode(response)#);
			
			if(identity.getUserId() eq ListGetAt(responseStruct.CUSTOM,1,',') AND arguments.itemId eq ListGetAt(responseStruct.CUSTOM,2,','))
			{
				//returnObj['details'] = responseStruct;
				returnObj['success'] = true;
				returnObj['error'] = '';
				returnObj['transactionId'] = responseStruct.TRANSACTIONID;
				returnObj['orderTime'] = responseStruct.ORDERTIME;
				returnObj['paymentStatus'] = responseStruct.PAYMENTSTATUS;
				returnObj['itemId'] = arguments.itemId;
				returnObj['userId'] = arguments.userId;			
				
			} else {
				returnObj['success'] = false;
				returnObj['error'] = 'Not a valid tranaction for this user';
			}
			
			return returnObj;
		</cfscript>
        
	</cffunction>
        
</cfcomponent>