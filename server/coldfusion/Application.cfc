<cfscript>
/**
@dateCreated "Sept 18, 2011"
@hint "You implement methods in Application.cfc to handle ColdFusion application events and set variables in the CFC to configure application characteristics."
*/


component output="false" {
	
	/* **************************** APPLICATION VARIABLES **************************** */
	THIS.name = "pptransact";
	THIS.applicationTimeout = createTimeSpan(0, 2, 0, 0);
    
    
    customtagpaths = "#getDirectoryFromPath(ExpandPath('lib/'))#";
	customtagpaths = ListAppend(customtagpaths,"#getDirectoryFromPath(ExpandPath('lib/services/'))#");
	customtagpaths = ListAppend(customtagpaths,"#getDirectoryFromPath(ExpandPath('/'))#");
	
	THIS.customTagPaths = customtagpaths; 
	
	THIS.serverSideFormValidation = true;
	THIS.sessionManagement = true;
	THIS.sessionTimeout = createTimeSpan(0, 0, 30, 0);
	
	THIS.setClientCookies = true;
	THIS.setDomainCookies = false;
	
	THIS.scriptProtect = true;
	THIS.secureJSON = false;
	THIS.secureJSONPrefix = "";
	
	
	THIS.enablerobustexception = true;


/* **************************** APPLICATION METHODS **************************** */

	public void function onApplicationEnd(struct ApplicationScope=structNew()) {
	
		return;
	}
	
	
	public boolean function onApplicationStart() {
   
		return true;
	}

	public void function onRequestEnd() {
	
		return;
	}

	
	public boolean function onRequestStart(required string TargetPage) {
		
	  	APIuserName = "joncle_1313106572_biz_api1.yahoo.com";
	  	APIPassword = "1313106611";
	   	APISignature = "ANaR-mYnO4B1i2mTfRzVmOSN.sl5A14g.6GhzSklnxQeH8jwxB-57XZ2";
		
	   	request.UID = "#APIuserName#";
	   	request.PASSWORD = "#APIPassword#";
	  	request.SIG = "#APISignature#";
	   
       	request.VER = "78";
		request.URLBASE = "https://api-3t.sandbox.paypal.com/nvp";
		request.URLREDIRECT = "https://www.sandbox.paypal.com/incontext?token=";
    
		return true;
	}


	public void function onSessionEnd(required struct SessionScope, struct ApplicationScope=structNew()) {
	
		return;
	}


	public void function onSessionStart() {
	
		return;
	}

}
</cfscript>