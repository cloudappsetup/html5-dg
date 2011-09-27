<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<?php
require_once("common.php");

$token = $_GET['token'];
$payerid = $_GET['PayerID'];
        
if ($token){
    //fetch payee information
    $postDetails = array(USER => UID,
                         PWD => PASSWORD,
                         SIGNATURE => SIG,
                         METHOD => "DoExpressCheckoutPayment",
                         VERSION => VER,
                         AMT => "1",
                         TOKEN => $token,
                         PAYERID => $payerid,
                         PAYMENTACTION => "sale");
    
    $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
    $postVals = rtrim(implode($arrPostVals), "&");
    $postVals = "USER=joncle_1313106572_biz_api1.yahoo.com&PWD=1313106611&SIGNATURE=ANaR-mYnO4B1i2mTfRzVmOSN.sl5A14g.6GhzSklnxQeH8jwxB-57XZ2&METHOD=DoExpressCheckoutPayment&VERSION=78&AMT=1&TOKEN=EC-4VT95373AP7445242&PAYERID=CBG5V7V3K5L6E&PAYMENTACTION=Sale";
        
    //$response = parseString(runCurl(URLBASE, $postVals));
    $response = runCurl(URLBASE, $postVals);
    echo $response;
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
    Thank you for the purchase!<br />
    <?= $response ?><br />
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>