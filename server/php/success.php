<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<?php
require_once("common.php");

$token = $_GET['token'];
        
if ($token){
    //fetch payee information
    $postDetails = array(USER => UID,
                         PWD => PASSWORD,
                         SIGNATURE => SIG,
                         METHOD => "GetExpressCheckoutDetails",
                         VERSION => VER,
                         TOKEN => $token);
    
    $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
    $postVals = rtrim(implode($arrPostVals), "&");
    
    var_dump($_REQUEST);
    
    echo "$postVals<br /><br />";
    var_dump(runCurl(URLBASE, $postData));
    
    //$payeeDetails = parseString(runCurl(URLBASE, $postData));
    
    //var_dump($payeeDetails);
} else {
    return "Token not present in query string: please ensure that this request has been called after user has been returned from setCheckout(...) call";
}


?>

<script>
function closeFlow() {
    parent.xconnection.releaseDG(<cfoutput>#serializeJSON(returnObj)#</cfoutput>);
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>