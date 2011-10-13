<?php
require_once("common.php");
require_once("identity.php");
require_once("inventory.php");

class pptransact{
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
    
    public function getToken($userId, $itemId, $qty){
        $itemObj = getItem($itemId);
        $itemObj['qty'] = $qty;
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
                             RETURNURL => "{$dirRoot}success.php?data=" . ($itemObj['qty'] * $itemObj['amt']) . "|$userId|$itemId",
                             CANCELURL => "{$dirRoot}cancel.php");
        
        $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
        $postVals = rtrim(implode($arrPostVals), "&");
        
        $response = parseString(runCurl(URLBASE, $postVals));
        
        //forward the user to login and accept transaction
        $redirect = sprintf("%s?token=%s", URLREDIRECT, urldecode($response["TOKEN"]));
        
        $returnObj = array(success => true,
                           redirecturl => $redirect);
        
        echo json_encode($returnObj);
    }
    
    public function commitPayment($userId = 0, $payerId, $token, $amt, $itemId){
        $returnObj = array();
        
        if (verifyUser($userId)){
            $postDetails = array(USER => UID,
                                 PWD => PASSWORD,
                                 SIGNATURE => SIG,
                                 METHOD => "DoExpressCheckoutPayment",
                                 VERSION => VER,
                                 AMT => $amt,
                                 TOKEN => $token,
                                 PAYERID => $payerId,
                                 PAYMENTACTION => "Sale");
    
            $arrPostVals = array_map(create_function('$key, $value', 'return $key."=".$value."&";'), array_keys($postDetails), array_values($postDetails));
            $postVals = rtrim(implode($arrPostVals), "&") ;
            
            $response = runCurl(URLBASE, $postVals);
            
            //HACK: On sandbox the first request will fail - we need to wait for 2 seconds and then try again
            if ($response == false){
                sleep(2);
                $response = parseString(runCurl(URLBASE, $postVals));
            } else {
                $response = parseString($response);
            }
            
            $returnObj['transactionId'] = $response["PAYMENTINFO_0_TRANSACTIONID"];
			$returnObj['orderTime'] = $response["PAYMENTINFO_0_ORDERTIME"];
			$returnObj['paymentStatus'] = $response["PAYMENTINFO_0_PAYMENTSTATUS"];
			$returnObj['itemId'] = $itemId;
			$returnObj['userId'] = $userId;
            
            recordPayment($returnObj);
        }
        
        return json_encode($returnObj);
    }
    
    
    public function verifyPurchase($userId = 0, $itemId = 0, $transactions){
        $arrTransactions = json_decode($transactions);
        $transactionId = null;
        
        $transactions = json_decode(stripslashes($transactions));
        
        for ($i = 0; $i < count($transactions); $i++){
            $transaction = json_decode($transactions[$i]);
            if ($transaction->itemId == $itemId){
                $transactionId = $transaction->transactionId;
            }
        }
        
        if ($transactionId){
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
                $returnObj = array(success => true,
                                   error => "",
                                   transactionId => $response["TRANSACTIONID"],
                                   orderTime => $response["ORDERTIME"],
                                   paymentStatus => $response["PAYMENTSTATUS"],
                                   itemId => $itemId,
                                   userId => $userId);
            }
        } else {
            $returnObj = array(success => false,
                               error => "Item not found in transaction history");
		}
        
        echo json_encode($returnObj);
    }
}

$transact = new pptransact();

switch($_GET["method"]){
    case "init": $connect->init(); break;
    case "getToken": $transact->getToken($_GET["userId"], $_GET["itemId"], $_GET["qty"]); break;
    case "commitPayment": $transact->commitPayment($_GET["userId"], $_GET["payerId"], $_GET["token"], $_GET["amt"], $_GET["itemId"]); break;
    case "verifyPayment": $transact->verifyPurchase($_GET["userId"], $_GET["itemId"], $_GET["transactions"]); break;
}
?>

