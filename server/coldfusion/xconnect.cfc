<cfcomponent>
	<cfscript>
		
		// create our objects to call methods on
		caller = createObject("component","/html5-dg/server/coldfusion/lib/services/CallerService");
		ec = createObject("component","/html5-dg/server/coldfusion/lib/ExpressCheckout");
		identity = createObject('component','/html5-dg/server/coldfusion/identity');
		inventory = createObject('component','/html5-dg/server/coldfusion/inventory');
		
	</cfscript>

    <cffunction name="connect" access="remote" returntype="any" returnFormat="JSON">
        
        <cfscript>
			var returnObj = StructNew();
			returnObj['success'] = true;
			returnObj['userId'] = identity.getUserId();
			returnObj['state'] = 'init';
			
			return serializeJSON(returnObj);
		</cfscript>	

	</cffunction>
    
    <cffunction name="createButton" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="itemId" type="string" required="no">
        
       	 <cfscript>
			var returnObj = StructNew();
			returnObj = inventory.getItem(arguments.itemId);
			returnObj['success'] = true;
			returnObj['buttonId'] = createUUID();
			returnObj['state'] = 'createButton';
			
			return serializeJSON(returnObj);
		</cfscript>	

	</cffunction>
    
    
     <cffunction name="setExpressCheckout" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="no">
        <cfargument name="itemId" type="string" required="yes">
        <cfargument name="qty" type="string" required="yes">
	
		<cfset var result = "">
        
        <cfscript>
	
			var returnObj = StructNew();
		
			var itemObj = StructNew();
			itemObj = inventory.getItem(arguments.itemId);
			itemObj['qty'] = arguments.qty;
		
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
				
				data.SHIPPINGAMT = "0";
				data.SHIPDISCAMT = "0";
				data.TAXAMT = "0";
				data.INSURANCEAMT = "0";
				form.paymentAction = "sale";
				form.paymentType="sale";
				data.PAYMENTREQUEST_0_CUSTOM = arguments.userId & ',' & itemObj.number;
				
				// set url info
				data.serverName = SERVER_NAME;
				data.serverPort = CGI.SERVER_PORT;
				data.contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
				data.protocol = CGI.SERVER_PROTOCOL;
				data.cancelPage = "cancel.cfm";
				data.returnPage = "success.cfm";
				
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
				returnObj['state'] = 'setExpressCheckout';
				
			}
			
			catch(any e) 
			{
				returnObj['success'] = true;
				returnObj['error'] = e.message;
				returnObj['state'] = 'setExpressCheckout';
			}
		
			return serializeJSON(returnObj);
		</cfscript>

	</cffunction>
    
    
     <cffunction name="verifyPurchase" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" default="0" required="yes">
        <cfargument name="transactions" type="any" required="no">
		
        
        <cfscript>
		var tnx = DeserializeJSON(arguments.transactions,true);
		var returnObj = StructNew();
		var transactionId = '0';
		</cfscript>
        
        
		<cfif isArray(tnx) >
             <cfloop from="1" to="#(ArrayLen(tnx) -1)#" index="i">
                <cfif tnx[i]['itemId'] eq arguments.itemId>
                    <cfset transactionId = tnx[i]['transactionId']>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        
		
		<cfscript>
		try {	
		
			if(transactionId neq 0)
			{
		
				data = StructNew();
				data.method = "GetTransactionDetails";
				data.transactionid = transactionId;
		
				requestData = ec.setGetCheckoutData(request,data);
				
				response = caller.doHttppost(requestData);
				responseStruct = StructNew();
				responseStruct = caller.getNVPResponse(#URLDecode(response)#);
				
				if(identity.getUserId() eq ListGetAt(responseStruct.CUSTOM,1,','))
				{
					returnObj['id'] = identity.getUserId();
					returnObj['success'] = true;
					returnObj['details'] = responseStruct;
					returnObj['state'] = 'verifyPurchase';
				} else {
					returnObj['id'] = identity.getUserId();
					returnObj['error'] = 'Not a valid tranaction for this user';
					returnObj['success'] = false;
					returnObj['state'] = 'verifyPurchase';
				}
			} else {
				returnObj['success'] = false;
				returnObj['error'] = 'Item not found in transaction history';
				returnObj['state'] = 'verifyPurchase';
			}
		}
		
		catch(any e) 
		{
			returnObj['success'] = false;
			returnObj['error'] = e.message;
			returnObj['state'] = 'verifyPurchase';
		}
		
		return serializeJSON(returnObj);
		</cfscript>
	
    	
    </cffunction>
	
	
</cfcomponent>