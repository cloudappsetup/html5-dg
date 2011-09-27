<?php
function getItem($itemId){
    $items = array(
        array(name => "Mega Sheilds",
              number => "123",
              qty => "1",
              taxamt => "0",
              amt => "1.00",
              desc => "Unlock the power!",
              category => "Digital"),
        array(name => "Laser Cannon",
              number => "456",
              qty => "1",
              taxamt => "0",
              amt => "1.25",
              desc => "Lock and load!",
              category => "Digital"));
    
    $returnObj = array();
    for ($i = 0; $i < count($items); $i++){
        if ($items[$i]['number'] == $itemId){
            $returnObj = $items[$i];
        }
    }
    
    return $returnObj;
}
?>