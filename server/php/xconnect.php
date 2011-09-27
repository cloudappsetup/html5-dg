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
        $dirRoot = sprintf("http://%s%s/", $_SERVER['SERVER_NAME'], dirname($_SERVER['PHP_SELF']));
        
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
                             RETURNURL => "{$dirRoot}success.php",
                             CANCELURL => "{$dirRoot}cancel.php");
        
        $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
        $postVals = rtrim(implode($arrPostVals), "&");
        
        $response = parseString(runCurl(URLBASE, $postVals));
        
        //forward the user to login and accept transaction
        $redirect = sprintf("%s?token=%s", URLREDIRECT, $response["TOKEN"]);
        //$redirect = sprintf("%s?cmd=_express-checkout&token=%s", URLREDIRECT, $response["TOKEN"]);
        
        $returnObj = array(success => true,
                           redirecturl => $redirect,
                           state => "startPurchase");
        
        echo json_encode($returnObj);
    }
    
    public function verifyPurchase($userId = 0, $itemId = 0, $transactions){
        $arrTransactions = json_decode($transactions);
        $transactionId = 0;
        
        for ($i = 0; $i < count($arrTransactions); $i++){
            if ($arrTransactions[$i]['itemId'] == $itemId){
                $transactionId = $arrTransactions[$i]['transactionId'];
            }
        }
        
        if ($transactionId != 0){
            $postDetails = array(USER => UID,
                                 PWD => PASSWORD,
                                 SIGNATURE => SIG,
                                 METHOD => "GetTransactionDetails",
                                 VERSION => VER,
                                 TRANSACTIONID => $transactionId);
            
            $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
            $postVals = rtrim(implode($arrPostVals), "&");
            
            $response = parseString(runCurl(URLBASE, $postVals));
            $custom = explode("%2c", $response["CUSTOM"]);
            
            if (getUserId() == $custom[0] && $itemId == $custom[1]){
                $returnObj = array(id => getUserId(),
                                   success => true,
                                   details => $response,
                                   state => "verifyPurchase");
            }
        } else {
            $returnObj = array(success => false,
                               error => "Item not found in transaction history",
                               state => "verifyPurchase");
		}
        
        echo json_encode($returnObj);
    }
}

$connect = new xconnect();

if ($_GET["method"] == "init"){ echo $connect->init(); }
if ($_GET["method"] == "startPurchase"){ $connect->startPurchase($_GET["itemId"], $_GET["qty"]); }
if ($_GET["method"] == "verifyPurchase"){ $connect->verifyPurchase($_GET["userId"], $_GET["itemId"], $_GET["transactions"]); }
?>

