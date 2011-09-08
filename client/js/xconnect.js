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
	var url, target, state, webToken;
	var xbutton = {itemId : "0",
				   top : "",
	               left : "",
				   height : "",
				   width : ""};
	
	return{
		init: function(url, target){
			this.url = url;
			this.target = target;
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		setTarget: function(newTarget) { this.target = newTarget; },
		getTarget: function() { return this.target; },
		
		connectResult: function(newConnData){
			xconnection.setState(newConnData.state);
			xconnection.setWebToken(newConnData.webToken);
		},
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setWebToken: function(newWebToken) { webToken = newWebToken; },
		getWebToken: function() { return webToken; },
		
		xbutton: function(itemId, top, left, height, width,buttonId) {
			this.xbutton.itemId = itemId;
			this.xbutton.top = top;
			this.xbutton.left = left;
			this.xbutton.height = height;
			this.xbutton.width = width;
			this.xbutton.buttonId = buttonId;
		},
		
		setTop: function(newTop) { this.xbutton.top = newTop; },
		getTop: function() { return this.xbutton.top; },
		setLeft: function(newY) { this.xbutton.top = newTop; },
		getLeft: function() { return this.xbutton.top; },
			
		setHeight: function(newHeight) { this.xbutton.height = newHeight; },
		getHeight: function() { return this.xbutton.height; },
		setWidth: function(newWidth) { this.xbutton.width = newWidth; },
		getWidth: function() { return this.xbutton.width; },
		setItemId: function(newItemId) { this.xbutton.itemId = newItemId; },
		getItemId: function() { return this.xbutton.itemId; },
		setButtonId: function(newButtonId) { this.xbutton.buttonId = newButtonId; },
		getButtonId: function() { return this.xbutton.buttonId; },
			 
		
		xButtonDisplay: function(){
			var top = xconnection.getTop();
			var left = xconnection.getLeft();
			var h = xconnection.getHeight();
			var w = xconnection.getWidth();
			var itemId = xconnection.getItemId();
		
			$('#' + xconnection.getTarget()).append('<div id="xButtonContainer" class="xButtonContainer">' + 
			'<div class="xButtonName"></div>' + 
			'<label>Quantity:</label><input type="number" min="0" max="10" step="1" value="2" class="xButtonQty">' + 
			'<img  src="https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif" class="xButtonImg" /></div>');
			
			$('#xButtonContainer').width(w);
			$('#xButtonContainer').height(h);
			$('#xButtonContainer').css({ "left": top + "px"});
			$('#xButtonContainer').css({ "top": left + "px"});
			
			xconnection.callServer('method=createButton&itemId=' + xconnection.getItemId(),function(data){
				console.log(data);
				console.log($('#xButtonQty'))
				xconnection.setItemId(data.number);
				xconnection.setButtonId(data.buttonId);
				$('#xButtonContainer .xButtonImg').attr('id',data.number);
				$('#xButtonContainer .xButtonQty').val(data.qty);
				$('#xButtonContainer .xButtonName').html(data.name);
				$('#xButtonContainer').attr('id', data.buttonId);
				
				
				
				$('#' +  data.buttonId + ' .xButtonImg').live('click', function() {	
					console.log(xconnection.getButtonId());
					var qty = $('#' + xconnection.getButtonId() + ' .xButtonQty').val();
					var data = 'method=setExpressCheckout&itemId=' + this.id + "&qty=" + qty;
					xconnection.callServer(data,function(data){
						console.log(data);
						startDGFlow(data.redirecturl);
					});
				});
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

startDGFlow = function(url) {	
	dg.startFlow(url);
}
		

function releaseDG(data) {
	console.log(data);
	dg.closeFlow();
	
}

