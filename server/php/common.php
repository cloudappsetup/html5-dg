<?php
define("UID", "YOUR USER ID");
define("PASSWORD", "YOUR PASSWORD");
define("SIG", "YOUR SIGNATURE");
define("VER", "78");
define("URLBASE", "https://api-3t.sandbox.paypal.com/nvp");
define("URLREDIRECT", "https://www.sandbox.paypal.com/incontext");

function parseString($string = null){
    $recordString = explode("&", $string);
    foreach ($recordString as $value){
        $singleRecord = explode("=", $value);
        $allRecords[$singleRecord[0]] = $singleRecord[1];
    }
        
    return $allRecords;
}
    
function runCurl($url, $postVals = null){
    $ch = curl_init($url);
        
    $options = array(
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 3
    );
        
    if ($postVals != null){
        $options[CURLOPT_POSTFIELDS] = $postVals;
        $options[CURLOPT_CUSTOMREQUEST] = "POST";  
    }
        
    curl_setopt_array($ch, $options);
        
    $response = curl_exec($ch);
    curl_close($ch);
        
    return $response;
}
?>
