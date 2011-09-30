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
require_once("xconnect.php");

$connect = new xconnect();
$data = explode("|", $_GET["data"]);
$returnObj = $connect->commitPayment($data[1], $_GET["PayerID"], $_GET["token"], $data[0], $data[2]);
?>

<script>
function closeFlow() {
    parent.xconnection.releaseDG(<?= json_encode($returnObj); ?>);
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:700px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!<br />
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>