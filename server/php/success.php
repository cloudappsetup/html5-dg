<?php
error_reporting(E_ERROR);
ini_set('display_errors','On');
?>
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
                         PAYMENTACTION => "Sale");
    
    $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
    $postVals = rtrim(implode($arrPostVals), "&") ;
    $response = runCurl(URLBASE, $postVals);
    
    //HACK: On sandbox the first request will fail - we need to wait for 2 seconds and then try again
    if ($response == false){
        sleep(2);
        $response = runCurl(URLBASE, $postVals);
    }
} else {
    return "Token not present in query string: please ensure that this request has been called after user has been returned from setCheckout(...) call";
}


?>

<script>
function closeFlow() {
    parent.xconnection.releaseDG(<?= json_encode($response); ?>);
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!<br />
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>