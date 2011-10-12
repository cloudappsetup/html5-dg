<cfscript>
/**
@dateCreated "Sept 18, 2011"
@hint "You implement methods in Application.cfc to handle ColdFusion application events and set variables in the CFC to configure application characteristics."
*/


component output="false" {
	
	/* **************************** APPLICATION VARIABLES **************************** */
	THIS.name = "xConnect";
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
    
    	request.SERVERURL = "https://api-3t.sandbox.paypal.com/nvp";
		
         /*
        APIuserName = "sdk-three_api1.sdk.com";
        APIPassword = "QFZCWN5HZM8VBG7Q";
        APISignature = "A.d9eRKfd1yVkRrtmMfCFLTqa6M9AyodL0SJkhYztxUi8W9pCXF6.4NI";
  	 	*/
		
	  	APIuserName = "sidney_1311957058_biz_api1.x.com";
	  	APIPassword = "1311957099";
	   	APISignature = "AsWOI0XsYOW6SY4-RFW6nmQX9L2GAx2Dvzlusmnc2lLkNlYS6cilwiEc";
		
	   	request.UNIPAYSUBJECT=""; 
	   	request.USER = "#APIuserName#";
	   	request.PWD = "#APIPassword#";
	  	request.SIGNATURE = "#APISignature#";
	   
        
       	request.PayPalURL = "https://www.sandbox.paypal.com/incontext?token=";
       	request.version = "78";
    
   		/*
    	By default the API requests doesn't go through proxy. To route the requests through a proxy server
         	set "useProxy" value as "true" and set values for proxyName and proxyPort. Set proxyName with
        the Host Name or the IP address of the proxy server. proxyPort should be a valid port number.
        eg: 
        useProxy = "true";
        proxyName = "127.0.0.1";
        proxyPort = "8081";
        */

        request.useProxy = "false";
        request.proxyName = "";
        request.proxyPort = "";
     
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