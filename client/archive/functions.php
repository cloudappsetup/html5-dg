
<?php
/*
 *functions.php
 *
 *holds functions for EC for index.php and return.php for Digital Goods EC Calls
 */
//Function PPHttpPost
//Makes an API call using an NVP String and an Endpoint
function PPHttpPost($my_endpoint, $my_api_str){
    // setting the curl parameters.
 $ch = curl_init();
 curl_setopt($ch, CURLOPT_URL, $my_endpoint);
 curl_setopt($ch, CURLOPT_VERBOSE, 1);
 // turning off the server and peer verification(TrustManager Concept).
 curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
 curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
 curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
 curl_setopt($ch, CURLOPT_POST, 1);
 // setting the NVP $my_api_str as POST FIELD to curl
 curl_setopt($ch, CURLOPT_POSTFIELDS, $my_api_str);
 // getting response from server
 $httpResponse = curl_exec($ch);
 if(!$httpResponse)
 {
   $response = "$API_method failed: ".curl_error($ch).'('.curl_errno($ch).')';
   return $response;
 }
 $httpResponseAr = explode("&", $httpResponse);
 $httpParsedResponseAr = array();
 foreach ($httpResponseAr as $i => $value) 
 {
  $tmpAr = explode("=", $value);
  if(sizeof($tmpAr) > 1) {
   $httpParsedResponseAr[$tmpAr[0]] = $tmpAr[1];
  }
 }

 if((0 == sizeof($httpParsedResponseAr)) || !array_key_exists('ACK', $httpParsedResponseAr)) {
  $response = "Invalid HTTP Response for POST request($my_api_str) to $API_Endpoint.";
  return $response;
 }

 return $httpParsedResponseAr;
}
?>