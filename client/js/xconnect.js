// JavaScript Document

var dg = new PAYPAL.apps.DGFlow({});
/*
connection(url,data)
url = the server side connection script
data = the query string to call method or pass variables.
*/


var xconnection = function(url) {
	var url, state, userid;
	
	return{
		init: function(url, completeCallBack){
			this.url = url;
			this.completeCallBack = completeCallBack;
			this.userId = 0;
			
			xconnection.callServer('method=connect',function(data){
				xconnection.setUserId(data.userId);
			});
			
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		setCompleteCallback: function(newCompleteCallBack) { this.completeCallBack = newCompleteCallBack; },
		getCompleteCallback : function() {return this.completeCallBack; },
		
		startPurchase: function(itemId,itemQty){
	
			var userId = xconnection.getUserId();
			var data = 'method=setExpressCheckout&itemId=' + itemId + "&qty=" + itemQty + "&userId=" + userId;
			xconnection.callServer(data,function(data){
					
				if(data.error)
				{
					alert('error starting purchase flow');
				} else {
					startDGFlow(data.redirecturl);
				}
			});
			
		},
		
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setUserId: function(newUserId) { userId = newUserId; },
		getUserId: function() { return userId; },
		
		xVerify: function(itemId,verifyCallBack){
			var userId = xconnection.getUserId();
			data = localStorage.getItem(userId);
			
			xconnection.callServer('method=verifyPurchase&userId=' + userId + '&transactions=' + data + '&itemId=' + itemId,function(data){
				
				if(data.success)
				{
					console.log(data.details['PAYMENTSTATUS']);
					console.log(data);
					if(typeof verifyCallBack == 'function'){
						verifyCallBack.call();
					}
					
				} else {
					alert('Error: ' + data.error);
				}
			});
		},
		
		startDGFlow : function(url) {	
			dg.startFlow(url);
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

/*
function supports_html5_storage() {
  try {
    return 'localStorage' in window && window['localStorage'] !== null;
  } catch (e) {
    return false;
  }
}
*/

	

function releaseDG(data) {
	
	var dataArray = JSON.parse(localStorage.getItem(xconnection.getUserId()));
	
	if(dataArray === null)
	{
		var dataArray = new Array();
		dataArray.push(data);
	} else {
		dataArray.push(data);
	}
	
	localStorage.setItem(xconnection.getUserId(), JSON.stringify(dataArray));
	
	dg.closeFlow();
	
}

