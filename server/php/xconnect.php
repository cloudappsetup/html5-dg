<?php
require_once("common.php");
require_once("identity.php");
require_once("inventory.php");

class xconnect{
    private $uid = null;
    private $password = null;
    private $signature = null;
    
    private $success;
    private $userId;
    private $state;
    
    public function __construct(){
        $this->success = true;
        $this->userId = getUserId();
        $this->state = "init";
    }
    
    public function init(){
        $returnObj = array(success => true,
                           userId => getUserId(),
                           state => "init");
        
        return json_encode($returnObj);
    }
    
    public function startPurchase($itemId, $qty){
        $itemObj = getItem($itemId);
        
        $postDetails = array(USER => UID,
                             PWD => PASSWORD,
                             SIGNATURE => SIG,
                             METHOD => "SetExpressCheckout",
                             VERSION => VER,
                             PAYMENTREQUEST_0_CURRENCYCODE => "USD",
                             PAYMENTREQUEST_0_AMT => $itemObj['qty'] * $itemObj['amt'],
                             PAYMENTREQUEST_0_TAXAMT => "0",
                             PAYMENTREQUEST_0_DESC => "Canvas Wars",
                             PAYMENTREQUEST_0_PAYMENTACTION => "Sale",
                             L_PAYMENTREQUEST_0_ITEMCATEGORY0 => $itemObj['category'],
                             L_PAYMENTREQUEST_0_NAME0 => $itemObj['name'],
                             L_PAYMENTREQUEST_0_NUMBER0 => $itemObj['number'],
                             L_PAYMENTREQUEST_0_QTY0 => $itemObj['qty'],
                             L_PAYMENTREQUEST_0_TAXAMT0 => "0",
                             L_PAYMENTREQUEST_0_AMT0 => $itemObj['amt'],
                             L_PAYMENTREQUEST_0_DESC0 => $itemObj['desc'],
                             PAYMENTREQUEST_0_SHIPPINGAMT => "0",
                             PAYMENTREQUEST_0_SHIPDISCAMT => "0",
                             PAYMENTREQUEST_0_TAXAMT => "0",
                             PAYMENTREQUEST_0_INSURANCEAMT => "0",
                             PAYMENTREQUEST_0_PAYMENTACTION => "sale",
                             L_PAYMENTTYPE0 => "sale",
                             PAYMENTREQUEST_0_CUSTOM => sprintf("%s,%s", $this->userId, $itemObj['number']),
                             RETURNURL => "http://jcleblanc.com/projects/php/success.php",
                             CANCELURL => "http://jcleblanc.com/projects/php/cancel.php");
        
        $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
        $postVals = rtrim(implode($arrPostVals), "&");
        
        $response = parseString(runCurl(URLBASE, $postVals));
        
        //forward the user to login and accept transaction
        $redirect = sprintf("%s?cmd=_express-checkout&token=%s", URLREDIRECT, $response["TOKEN"]);
        header("Location: $redirect");
    }
}

$connect = new xconnect();
$connect->startPurchase("123", "2");

?>

