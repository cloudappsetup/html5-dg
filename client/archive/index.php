
<?php
/*
 *DG with EC
 */

 /*
  *index.php
  *
  *This page will handle the SetExpressCheckout API Call and the redirect
  */
  //set include
  include('functions.php');
  
  // Set API creds and version greater than 65.1, also set endpoint and redirect url
//**************************************************//
// This is where you would set your API Credentials //
// Please note this is not considered "SECURE" this // 
// is an example only. It is NOT Recommended to use //
// this method in production........................//
//**************************************************//
  $APIUSERNAME  = "sidney_1311957058_biz_api1.x.com";
  $APIPASSWORD  = "1311957099";
  $APISIGNATURE = "AsWOI0XsYOW6SY4-RFW6nmQX9L2GAx2Dvzlusmnc2lLkNlYS6cilwiEc";
  $ENDPOINT     = "https://api-3t.sandbox.paypal.com/nvp";
  $VERSION      = "65.1"; //must be >= 65.1
  $REDIRECTURL  = "https://www.sandbox.paypal.com/incontext?token=";
  
  //Build the Credential String:
  $cred_str = "USER=" . $APIUSERNAME . "&PWD=" . $APIPASSWORD . "&SIGNATURE=" . $APISIGNATURE . "&VERSION=" . $VERSION;
  //For Testing this is hardcoded. You would want to set these variable values dynamically
  $nvp_str  = "&METHOD=SetExpressCheckout" 
   . "&RETURNURL=http://localhost/html5dg/return.php" //set your Return URL here
      . "&CANCELURL=http://localhost/html5dg/return.php" //set your Cancel URL here
            . "&PAYMENTREQUEST_0_CURRENCYCODE=USD"
      . "&PAYMENTREQUEST_0_AMT=.99"
   . "&PAYMENTREQUEST_0_ITEMAMT=.99"
   . "&PAYMENTREQUEST_0_TAXAMT=0"
   . "&PAYMENTREQUEST_0_DESC=Movies"
   . "&PAYMENTREQUEST_0_PAYMENTACTION=Sale"
   . "&L_PAYMENTREQUEST_0_ITEMCATEGORY0=Digital"
   . "&L_PAYMENTREQUEST_0_NAME0=Mega Sheilds"
   . "&L_PAYMENTREQUEST_0_NUMBER0=101"
   . "&L_PAYMENTREQUEST_0_QTY0=1"
   . "&L_PAYMENTREQUEST_0_TAXAMT0=0"
   . "&L_PAYMENTREQUEST_0_AMT0=.99"
   . "&L_PAYMENTREQUEST_0_DESC0=Download";
   
//combine the two strings and make the API Call
$req_str = $cred_str . $nvp_str;
$response = PPHttpPost($ENDPOINT, $req_str);
//check Response
if($response['ACK'] == "Success" || $response['ACK'] == "SuccessWithWarning")
{
//setup redirect URL
$redirect_url = $REDIRECTURL . urldecode($response['TOKEN']);
}
else if($response['ACK'] == "Failure" || $response['ACK'] == "FailureWithWarning")
{
echo "The API Call Failed";
print_r($response);
}
  ?>
  
  
  <html>
  <head>
  <title>PayPal - Digital Goods with Express Checkout</title>
  <script src ='dg.js' type='text/javascript'></script>
  </head>
  <body>
  <p>At this point you would have had the user add everything to the cart, then you would do the SetEC Call and display this button</p>
  <?php echo "<a href=" . $redirect_url . " id='submitBtn'><img src='https://www.paypal.com/en_US/i/btn/btn_dg_pay_w_paypal.gif' border='0' /></a>"; ?>
  <script>
var dg = new PAYPAL.apps.DGFlow({
// the HTML ID of the form submit button which calls setEC
trigger: "submitBtn"
});
</script>
  </body>
  </html>
  