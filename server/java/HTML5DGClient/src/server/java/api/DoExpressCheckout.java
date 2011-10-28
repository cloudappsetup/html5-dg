/*
 * Copyright 2005, 2008 PayPal, Inc. All Rights Reserved.
 *
 * DoExpressCheckoutPayment NVP example; last modified 08MAY23. 
 *
 * Complete an Express Checkout transaction.  
 */
package server.java.api;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import server.java.Common;
import server.java.data.CheckoutRequestObj;
import com.paypal.sdk.core.nvp.NVPEncoder;
import com.paypal.sdk.services.NVPCallerServices;

/**
 * PayPal Java SDK sample code
 */
public class DoExpressCheckout {
	private volatile static DoExpressCheckout s_singleton =  new DoExpressCheckout();
	private static final Log log = LogFactory.getLog(DoExpressCheckout.class);

	private DoExpressCheckout() {

	}

	public static DoExpressCheckout getInstance() {
		return s_singleton;
	}

	private NVPCallerServices caller = null;

	public String doExpressCheckoutCall(CheckoutRequestObj ecReqObj) {
		log.info("Start API Call - DoExpressCheckoutPayment");
		NVPEncoder encoder = new NVPEncoder();
		String nvpResponse = "";
		try {
			caller = new NVPCallerServices();
			caller.setAPIProfile(Common.getAPIProfile());
			encoder.add("VERSION", "78");
			encoder.add("METHOD", "DoExpressCheckoutPayment");
			encoder.add("TOKEN", ecReqObj.getToken());
			encoder.add("PAYERID", ecReqObj.getPayerId());
			encoder.add("AMT", new Double(ecReqObj.getAmount()).toString());
			encoder.add("PAYMENTACTION", ecReqObj.getPaymentType());
			encoder.add("CURRENCYCODE", ecReqObj.getCurrencyCode());
			// Execute the API operation and obtain the response.
			String NVPRequest = encoder.encode();
			nvpResponse = caller.call(NVPRequest);
			
		} catch (Exception ex) {
			log.error(ex);
		}
		log.info("End API Call - DoExpressCheckoutPayment");
		return nvpResponse;
	}
}
