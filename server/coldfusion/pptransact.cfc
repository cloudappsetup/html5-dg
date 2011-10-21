<cfcomponent>
	<cfscript>
		
		// create our objects to call methods on
		caller = createObject("component","CallerService");
		identity = createObject('component','identity');
		inventory = createObject('component','inventory');
		
	</cfscript>
    
    
   <cffunction name="init" access="remote" returntype="any" returnFormat="JSON">
       
       	<cfscript>
			var returnObj = StructNew();
			
			returnObj['success'] = true;
			returnObj['userId'] = identity.getUserId();
			returnObj['state'] = init;
		
			return returnObj;
    	</cfscript>
    </cffunction>
 
   <cffunction name="getToken" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" required="yes">
        <cfargument name="qty" type="string" required="yes">
	
		<cfset var result = "">
        
        <cfscript>
	
			var returnObj = StructNew();
		
			var itemObj = StructNew();
			itemObj = inventory.getItem(arguments.itemId);
			itemObj['qty'] = arguments.qty;
	
			
			if (identity.verifyUser(arguments.userId))
				{	
				try {	
					data = StructNew();
					
					data.USER = request.UID;
					data.PWD = request.PASSWORD;
					data.SIGNATURE = request.SIG;
					data.METHOD = "SetExpressCheckout";
					data.VERSION = request.VER;
					data.URLBASE = request.URLBASE;
					data.USEPROXY = false;
					
					data.PAYMENTREQUEST_0_CURRENCYCODE="USD";
					data.PAYMENTREQUEST_0_AMT=(itemObj.qty * itemObj.amt);
					data.PAYMENTREQUEST_0_TAXAMT="0";
					
					data.PAYMENTREQUEST_0_DESC="JS Wars";
					data.PAYMENTREQUEST_0_PAYMENTACTION="Sale";
			 
					data.L_PAYMENTREQUEST_0_ITEMCATEGORY0=itemObj.category;
					data.L_PAYMENTREQUEST_0_NAME0=itemObj.name;
					data.L_PAYMENTREQUEST_0_NUMBER0=itemObj.number;
					data.L_PAYMENTREQUEST_0_QTY0=itemObj.qty;
					data.L_PAYMENTREQUEST_0_TAXAMT0="0";
					data.L_PAYMENTREQUEST_0_AMT0=itemObj.amt;
					data.L_PAYMENTREQUEST_0_DESC0=itemObj.desc;
					
					data.PAYMENTREQUEST_0_SHIPPINGAMT = "0";
					data.PAYMENTREQUEST_0_SHIPDISCAMT = "0";
					data.PAYMENTREQUEST_0_TAXAMT = "0";
					data.PAYMENTREQUEST_0_INSURANCEAMT = "0";
					data.PAYMENTREQUEST_0_PAYMENTACTION = "sale";
					data.L_PAYMENTTYPE0 = "sale";
				
					data.PAYMENTREQUEST_0_CUSTOM = arguments.userId & ',' & itemObj.number;
					
					// set url info
					var serverName = SERVER_NAME;
					var serverPort = CGI.SERVER_PORT;
					var contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
					var protocol = CGI.SERVER_PROTOCOL;
					var cancelPage = "cancel.cfm";
					var returnPage = "success.cfm?userId=" & URLEncodedFormat(arguments.userId) & '&itemId=' & URLEncodedFormat(arguments.itemId);
					var amt = 0;
					var itemAmt = (itemObj.qty * itemObj.amt);
					data.amt= #DecimalFormat(Evaluate(itemAmt + data.PAYMENTREQUEST_0_SHIPPINGAMT + data.PAYMENTREQUEST_0_SHIPDISCAMT + data.PAYMENTREQUEST_0_TAXAMT + data.PAYMENTREQUEST_0_INSURANCEAMT))#;
					data.PAYMENTREQUEST_0_AMT = data.amt;
					data.maxamt=#DecimalFormat(Evaluate(#amt# + 1.25))#;
						
					data.cancelURL = "http://" & serverName & ":" & serverPort & contextPath & cancelPage;	
					data.returnURL = "http://" & serverName & ":" & serverPort & contextPath & returnPage & "&amt=#data.amt#&currencycode=#data.PAYMENTREQUEST_0_CURRENCYCODE#";
					
					response = caller.doHttppost(data);
					
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
					redirecturl = request.URLREDIRECT & token;
					
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
					data.USER = request.UID;
					data.PWD = request.PASSWORD;
					data.SIGNATURE = request.SIG;
					data.METHOD = "DoExpressCheckoutPayment";
					data.VERSION = request.VER;
					data.URLBASE = request.URLBASE;
					data.USEPROXY = false; 
					data.TOKEN = arguments.token;
					data.AMT = arguments.amt;
					data.PAYERID = arguments.payerid;
					data.PAYMENTACTION = "sale";
					
					response = caller.doHttppost(data);
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
			data.USER = request.UID;
			data.PWD = request.PASSWORD;
			data.SIGNATURE = request.SIG;
			data.method = "GetTransactionDetails";
			data.VERSION = request.VER;
			data.URLBASE = request.URLBASE;
			data.USEPROXY = false; 
			data.transactionid = transactionId;
	
			
			response = caller.doHttppost(data);
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