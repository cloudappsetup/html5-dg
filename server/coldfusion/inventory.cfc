<cfcomponent>
	<cffunction name="getItemDetails" access="public" returntype="struct">
		<cfargument name="itemId" type="string" required="yes">
        
        <cfscript>
			
			var items = ArrayNew(1);
			
			var itemObj = StructNew();
			itemObj['name'] = "5 Super Missiles";
			itemObj['number'] ="123";
			itemObj['qty'] = "1";	
			itemObj['taxamt'] = "0";
			itemObj['amt'] = "1.00";
			itemObj['desc'] = "Unlock the power!";
			itemObj['category'] = "Digital";
			temp = ArrayAppend(items,itemObj);
			
			var itemObj = StructNew();
			itemObj['name'] = "Laser Cannon";
			itemObj['number'] ="456";
			itemObj['qty'] = "1";	
			itemObj['taxamt'] = "0";
			itemObj['amt'] = "1.25";
			itemObj['desc'] = "Lock and load!";
			itemObj['category'] = "Digital";
			var temp = ArrayAppend(items,itemObj);
		
		</cfscript>
        
        <cfset var returnObj = StructNew()>
        
        <cfloop from="1" to="#ArrayLen(items)#" index="i">
			<cfif items[i].number eq arguments.itemId>
                <cfset returnObj = items[i]>
                <cfbreak>
            </cfif>
        </cfloop>
        
    	<cfreturn returnObj>
	</cffunction>
</cfcomponent>