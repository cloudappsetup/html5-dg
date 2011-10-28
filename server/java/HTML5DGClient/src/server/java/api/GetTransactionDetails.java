/*
 * Copyright 2005, 2008 PayPal, Inc. All Rights Reserved.
 *
 * GetTransactionDetails NVP example; last modified 08MAY23. 
 *
 * Get detailed information about a single transaction.  
 */
package server.java.api;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import server.java.Common;
import com.paypal.sdk.core.nvp.NVPEncoder;
import com.paypal.sdk.services.NVPCallerServices;

/**
 * PayPal Java SDK sample code
 */
public class GetTransactionDetails {

	private static GetTransactionDetails s_singleton = new GetTransactionDetails();
	private static final Log log = LogFactory.getLog(GetTransactionDetails.class);
	private GetTransactionDetails() {

	}

	public static GetTransactionDetails getInstance() {
		return s_singleton;
	}

	public String getTransactionDetailsCode(String transactionId) {
		log.info("Start API Call - GetTransactionDetails");
		NVPCallerServices caller = null;
		NVPEncoder encoder = new NVPEncoder();
		String nvpResponse = "";
		try {
			caller = new NVPCallerServices();
			caller.setAPIProfile(Common.getAPIProfile());
			encoder.add("VERSION", "63.0");
			encoder.add("METHOD", "GetTransactionDetails");
			encoder.add("TRANSACTIONID", transactionId);
			String nvpRequest = encoder.encode();
			nvpResponse = caller.call(nvpRequest);
			log.info(nvpResponse);			

		} catch (Exception ex) {
			log.error(ex);
		}
		log.info("End API Call - GetTransactionDetails");
		return nvpResponse;

	}
}
