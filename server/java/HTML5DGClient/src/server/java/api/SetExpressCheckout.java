package server.java.api;

/*
 * Copyright 2005, 2008 PayPal, Inc. All Rights Reserved.
 *
 * SetExpressCheckout NVP example; last modified 08MAY23. 
 *
 * Initiate an Express Checkout transaction.  
 */

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import server.java.Common;
import server.java.data.CheckoutRequestObj;
import com.paypal.sdk.core.nvp.NVPEncoder;
import com.paypal.sdk.services.NVPCallerServices;

/**
 * PayPal Java SDK sample code
 */
public class SetExpressCheckout {

	private static SetExpressCheckout s_singleton = new SetExpressCheckout();
	private static final Log log = LogFactory.getLog(SetExpressCheckout.class);

	private SetExpressCheckout() {

	}

	public static SetExpressCheckout getInstance() {
		return s_singleton;
	}

	private NVPCallerServices caller = null;

	public String setExpressCheckoutCall(CheckoutRequestObj ecReqObj) {
		log.info("Start API Call - SetExpressCheckout");
		NVPEncoder encoder = new NVPEncoder();
		String nvpResponse = "";
		try {
			caller = new NVPCallerServices();
			caller.setAPIProfile(Common.getAPIProfile());
			encoder.add("VERSION", "78");
			encoder.add("METHOD", "SetExpressCheckout");

			// Add request-specific fields to the request string.
			encoder.add("RETURNURL", ecReqObj.getReturnURL());
			encoder.add("CANCELURL", ecReqObj.getCancelURL());
			encoder.add("PAYMENTREQUEST_0_CURRENCYCODE",
					ecReqObj.getCurrencyCode());
			encoder.add("PAYMENTREQUEST_0_AMT",
					new Double(ecReqObj.getAmount()).toString());
			encoder.add("PAYMENTREQUEST_0_TAXAMT", "0");
			encoder.add("PAYMENTREQUEST_0_DESC", ecReqObj.getDesc());
			encoder.add("PAYMENTREQUEST_0_PAYMENTACTION",
					ecReqObj.getPaymentType());
			encoder.add("PAYMENTREQUEST_0_CUSTOM", ecReqObj.getUserInfo());
			encoder.add("L_PAYMENTREQUEST_0_ITEMCATEGORY0", "Digital");
			encoder.add("L_PAYMENTREQUEST_0_NAME0", ecReqObj.getName());
			encoder.add("L_PAYMENTREQUEST_0_NUMBER0", ecReqObj.getNumber());
			encoder.add("L_PAYMENTREQUEST_0_QTY0",
					new Integer(ecReqObj.getQty()).toString());
			encoder.add("L_PAYMENTREQUEST_0_TAXAMT0", "0");
			encoder.add("L_PAYMENTREQUEST_0_AMT0",
					new Double(ecReqObj.getAmount0()).toString());
			encoder.add("L_PAYMENTREQUEST_0_DESC0", ecReqObj.getDesc());
			encoder.add("SHIPPINGAMT", ecReqObj.getShipmentAmt());
			encoder.add("SHIPDISCAMT", ecReqObj.getShipDiscAmt());
			encoder.add("TAXAMT", ecReqObj.getTaxAmt());
			encoder.add("INSURANCEAMT", ecReqObj.getInsuranceAmt());

			// Execute the API operation and obtain the response.
			String NVPRequest = encoder.encode();
			nvpResponse = caller.call(NVPRequest);			
		} catch (Exception ex) {
			log.error(ex);
		}
		log.info("End API Call - SetExpressCheckout");
		return nvpResponse;
	}
}
