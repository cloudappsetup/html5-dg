// JavaScript Document

var dg = new PAYPAL.apps.DGFlow({});
/*
connection(url,data)
url = the server side connection script
data = the query string to call method or pass variables.
target = the id of the dom element you are targeting.
targetType = either canvas or div
*/



var xconnection = function(url, target) {
	var url, target, state, userid;
	var xButton = {itemId : "0",
				   top : "",
	               left : "",
				   height : "",
				   width : ""};
	
	return{
		init: function(url, target,completeCallBack){
			this.url = url;
			this.target = target;
			this.completeCallBack = completeCallBack;
			this.userId = 0;
			var xC = $('<div id="xContainer" class="xContainer"></div>'); 
			$('#' + target).append(xC);
			
			xconnection.callServer('method=connect',function(data){
				console.log(data.userId);
				xconnection.setUserId(data.userId);
			});
			
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		setTarget: function(newTarget) { this.target = newTarget; },
		getTarget: function() { return this.target; },
		setCompleteOrderCallback: function(newCompleteCallBack) { this.completeCallBack = newCompleteCallBack; },
		getCompleteOrderCallback : function() {return this.completeCallBack; },
		/*
		connectResult: function(newConnData){
			xconnection.setState(newConnData.state);
			xconnection.setUserId(newConnData.userId);
			
		},
		*/
		
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setUserId: function(newUserId) { userId = newUserId; },
		getUserId: function() { return userId; },
		
		xButton: function(itemId, top, right, bottom, left, height, width, buttonId) {
			this.xButton.itemId = itemId;
			this.xButton.top = top;
			this.xButton.right = right;
			this.xButton.bottom = bottom;
			this.xButton.left = left;
			this.xButton.height = height;
			this.xButton.width = width;
			this.xButton.buttonId = buttonId;
		},
		
		setTop: function(newTop) { this.xButton.top = newTop; },
		getTop: function() { return this.xButton.top; },
		
		setRight: function(newRight) { this.xButton.right = newRight; },
		getRight: function() { return this.xButton.right; },
		
		setBottom: function(newBottom) { this.xButton.bottom = newBottom; },
		getBottom: function() { return this.xButton.bottom; },
		
		setLeft: function(newLeft) { this.xButton.left = newLeft; },
		getLeft: function() { return this.xButton.left; },
			
		setHeight: function(newHeight) { this.xButton.height = newHeight; },
		getHeight: function() { return this.xButton.height; },
		setWidth: function(newWidth) { this.xButton.width = newWidth; },
		getWidth: function() { return this.xButton.width; },
		setItemId: function(newItemId) { this.xButton.itemId = newItemId; },
		getItemId: function() { return this.xButton.itemId; },
		setButtonId: function(newButtonId) { this.xButton.buttonId = newButtonId; },
		getButtonId: function() { return this.xButton.buttonId; },
		
			 
		
		xButtonDisplay: function(){
			var top = xconnection.getTop();
			var right = xconnection.getRight();
			var bottom = xconnection.getBottom();
			var left = xconnection.getLeft();
			var h = xconnection.getHeight();
			var w = xconnection.getWidth();
			var itemId = xconnection.getItemId();
		
			
			var xBC = $('<div id="xButtonContainer" class="xButtonContainer">' + 
			'<div class="xClose" ></div>' + 
			'<div class="xButtonName"></div>' + 
			'<div class="xButtonDesc"></div>' + 
			'<div class="xButtonAmt"></div>' + 
			'<label>Quantity:</label><input type="number" min="0" max="10" step="1" value="2" class="xButtonQty">' + 
			'<div class="xButtonLink">&nbsp;</div></div>').hide().fadeIn(500);
			console.log(xBC);
			$('#xContainer').append(xBC);
			
			$('#xButtonContainer').width(w);
			$('#xButtonContainer').height(h);
			
			if(top != null)
			{
				$('#xButtonContainer').css({ "top": top + "px"});
			}
			
			if(bottom != null)
			{
				$('#xButtonContainer').css({ "bottom": bottom + "px"});
			}
			
			if(right != null)
			{
				$('#xButtonContainer').css({ "right": right + "px"});
			}
			
			if(left != null)
			{
				$('#xButtonContainer').css({ "left": left + "px"});
			}
			
			xconnection.callServer('method=createButton&itemId=' + xconnection.getItemId(),function(data){
				xconnection.setItemId(data.number);
				xconnection.setButtonId(data.buttonId);
				
				$('#xButtonContainer .xButtonLink').attr('id',data.number);
				$('#xButtonContainer .xButtonQty').val(data.qty);
				$('#xButtonContainer .xButtonName').html(data.name);
				$('#xButtonContainer .xButtonDesc').html(data.desc);
				$('#xButtonContainer').attr('id', data.buttonId);
				
				$('#' +  data.buttonId + ' .xClose').live('click', function() {
					$('#' + xconnection.getButtonId()).fadeOut(500);
				});
				
				$('#' +  data.buttonId + ' .xButtonLink').live('click', function() {	
					console.log(xconnection.getButtonId());
					var qty = $('#' + xconnection.getButtonId() + ' .xButtonQty').val();
					var userId = xconnection.getUserId();
					var data = 'method=setExpressCheckout&itemId=' + this.id + "&qty=" + qty + "&userId=" + userId;
					xconnection.callServer(data,function(data){
						console.log(data);
						if(data.error)
						{
							alert('error starting purchase flow');
						} else {
							startDGFlow(data.redirecturl);
						}
					});
				});
			});
			
			
			
		},
		
		xVerify: function(itemId){
			var userId = xconnection.getUserId();
			data = localStorage.getItem(userId);
	
			xconnection.callServer('method=verifyPurchase&userId=' + userId + '&transactions=' + data + '&itemId=' + itemId,function(data){
				var obj = $.parseJSON(data);
				//console.log(data.details['PAYMENTSTATUS']);
				console.log(data);
			});
			
		
		},
		
		
		callServer : function(data,callbackFnk){
			$.ajax({
				url: xconnection.getUrl(),
				data: data,
				success: function(data){
					var obj = $.parseJSON(data);
					
					if(typeof callbackFnk == 'function'){
						callbackFnk.call(this, obj);
					}
				}
			});	
		}
		
		
	}
	
}();

function supports_html5_storage() {
  try {
    return 'localStorage' in window && window['localStorage'] !== null;
  } catch (e) {
    return false;
  }
}

startDGFlow = function(url) {	
	dg.startFlow(url);
}
		

function releaseDG(data) {
	
	var dataArray = JSON.parse(localStorage.getItem(xconnection.getUserId()));
	
	if(dataArray === null)
	{
		console.log('undefined');
		
		var dataArray = new Array();
		dataArray.push(data);
	} else {
		console.log('defined');
		console.log(dataArray);
		
		dataArray.push(data);
	}
	
	localStorage.setItem(xconnection.getUserId(), JSON.stringify(dataArray));
	
	dg.closeFlow();
	
	$('#' + xconnection.getButtonId()).fadeOut(500, function()
	{
		var callbackFnk = xconnection.getCompleteOrderCallback();
		if(typeof callbackFnk == 'function'){
			callbackFnk.call();
		}
	});
	
}

