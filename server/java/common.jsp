<%
	/*==================================================================
	 PayPal Express Checkout Module
	 ===================================================================
	--------------------------------------------------------------------
	 */
%>

<%@ page language="java"%>
<%@ page language="java" import="java.net.URLDecoder.*"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.util.HashMap"%>
<%@ page language="java" import="java.util.StringTokenizer.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.net.*"%>
<%@ page language="java" import="javax.net.ssl.*"%>

<%
	
	gv_APIUserName = "YOUR API USERNAME";
	gv_APIPassword = "PASSWORD";
	gv_APISignature = "SIGNATURE";

	//BN Code is only applicable for partners
	gv_BNCode = "PP-ECWizard";
	gv_APIEndpoint = "https://api-3t.sandbox.paypal.com/nvp";
	PAYPAL_URL = "https://www.sandbox.paypal.com/incontext?token=";
	

	String HTTPREQUEST_PROXYSETTING_SERVER = "";
	String HTTPREQUEST_PROXYSETTING_PORT = "";
	boolean USE_PROXY = false;

	gv_Version = "78";

	//WinObjHttp Request proxy settings.
	gv_ProxyServer = HTTPREQUEST_PROXYSETTING_SERVER;
	gv_ProxyServerPort = HTTPREQUEST_PROXYSETTING_PORT;
	gv_Proxy = 2; //'setting for proxy activation
	gv_UseProxy = USE_PROXY;
%>

<%!String gv_APIEndpoint;
	String gv_APIUserName;
	String gv_APIPassword;
	String gv_APISignature;
	String gv_BNCode;

	String gv_Version;
	String gv_nvpHeader;
	String gv_ProxyServer;
	String gv_ProxyServerPort;
	int gv_Proxy;
	boolean gv_UseProxy;
	String PAYPAL_URL;

	


	/*********************************************************************************
	 * httpcall: Function to perform the API call to PayPal using API signature
	 * 	@methodName is name of API  method.
	 * 	@nvpStr is nvp string.
	 * returns a NVP string containing the response from the server.
	 *********************************************************************************/
	public HashMap httpcall(String methodName, String nvpStr) {

		String version = "2.3";
		String agent = "Mozilla/4.0";
		String respText = "";
		HashMap nvp = null;

		//deformatNVP( nvpStr );	
		String encodedData = "METHOD=" + methodName + "&VERSION=" + gv_Version
				+ "&PWD=" + gv_APIPassword + "&USER=" + gv_APIUserName
				+ "&SIGNATURE=" + gv_APISignature + nvpStr+ "&BUTTONSOURCE="
						+ gv_BNCode;

		try {
			URL postURL = new URL(gv_APIEndpoint);
			HttpURLConnection conn = (HttpURLConnection) postURL
					.openConnection();

			// Set connection parameters. We need to perform input and output, 
			// so set both as true. 
			conn.setDoInput(true);
			conn.setDoOutput(true);

			// Set the content type we are POSTing. We impersonate it as 
			// encoded form data 
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setRequestProperty("User-Agent", agent);

			//conn.setRequestProperty( "Content-Type", type );
			conn.setRequestProperty("Content-Length",
					String.valueOf(encodedData.length()));
			conn.setRequestMethod("POST");

			// get the output stream to POST to. 
			DataOutputStream output = new DataOutputStream(
					conn.getOutputStream());
			output.writeBytes(encodedData);
			output.flush();
			output.close();

			// Read input from the input stream.
			DataInputStream in = new DataInputStream(conn.getInputStream());
			int rc = conn.getResponseCode();
			if (rc != -1) {
				BufferedReader is = new BufferedReader(new InputStreamReader(
						conn.getInputStream()));
				String _line = null;
				while (((_line = is.readLine()) != null)) {
					respText = respText + _line;
				}
				nvp = deformatNVP(respText);
			}
			return nvp;
		} catch (IOException e) {
			// handle the error here
			return null;
		}
	}

	/*********************************************************************************
	 * deformatNVP: Function to break the NVP string into a HashMap
	 * 	pPayLoad is the NVP string.
	 * returns a HashMap object containing all the name value pairs of the string.
	 *********************************************************************************/
	public HashMap deformatNVP(String pPayload) {
		HashMap nvp = new HashMap();
		StringTokenizer stTok = new StringTokenizer(pPayload, "&");
		while (stTok.hasMoreTokens()) {
			StringTokenizer stInternalTokenizer = new StringTokenizer(
					stTok.nextToken(), "=");
			if (stInternalTokenizer.countTokens() == 2) {
				String key = URLDecoder.decode(stInternalTokenizer.nextToken());
				String value = URLDecoder.decode(stInternalTokenizer
						.nextToken());
				nvp.put(key.toUpperCase(), value);
			}
		}
		return nvp;
	}

%>
