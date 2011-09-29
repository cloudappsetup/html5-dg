<cfcomponent>

	<cffunction name="verifyUser" access="public" returntype="string">
		<cfargument name="userId" type="string" default="0" required="yes">
        <cfset var YourSessionUserId = '888888'>	
            
    	<cfreturn (arguments.userId eq YourSessionUserId)>
	</cffunction>

	<cffunction name="getUserId" access="public" returntype="string">
		
		<cfset var result= '888888'>
	
    	<cfreturn result>
	</cffunction>
    
    <cffunction name="recordPayment" access="public" returntype="string">
    	<cfargument name="paymentObj" type="struct" default="" required="yes">
		
        <cfset var userId = arguments.paymentObj['userId']>
        <cfset var itemId = arguments.paymentObj['itemId']>
        <cfset var transactionId = arguments.paymentObj['transactionId']>
        <cfset var paymentStatus = arguments.paymentObj['paymentStatus']>
        <cfset var orderTime = arguments.paymentObj['orderTime']>
        
        <!--- INSERT YOUR CODE TO SAVE THE PAYMENT DATA --->
	
	</cffunction>
    
    <cffunction name="verifyPayment" access="public" returntype="boolean">
    	<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" default="0" required="yes">
        <cfset var result = false>
        
         <!--- INSERT YOUR CODE TO QUERY PAYMENT DATA and RETURN TRUE if MATCH FOUND--->
        
		
		<cfreturn result>
	</cffunction>
    
    <cffunction name="getPayment" access="public" returntype="struct">
    	<cfargument name="userId" type="string" default="0" required="yes">
        <cfargument name="itemId" type="string" default="0" required="yes">
        <cfset var returnObj = StructNew()>
        
         <!--- INSERT YOUR CODE TO QUERY PAYMENT DATA and RETURN PAYMENT STRUCTURE--->
        <cfscript>
		
        	returnObj['success'] = true;
            returnObj['error'] = '';
            returnObj['transactionId'] = "12345678";
            returnObj['orderTime'] = "2011-09-29T04:47:51Z";
            returnObj['paymentStatus'] = "Pending";
            returnObj['itemId'] = "123";
            returnObj['userId'] = "888888";		
		</cfscript>
        
		<cfreturn returnObj>
	</cffunction>
</cfcomponent>