// JavaScript Document

var dg = new PAYPAL.apps.DGFlow({});
/*
connection(url,data)
url = the server side connection script
data = the query string to call method or pass variables.
*/


var xconnection = function(url) {
	var url;
	
	return{
		init: function(url){
			this.url = url;
			xconnection.setUserId(0);
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		
		startPurchase: function(itemId,itemQty,userId,successPurchaseCallBack,failPurchaseCallBack){
			xconnection.setSuccessPurchaseCallBack(successPurchaseCallBack);
			xconnection.setFailPurchaseCallBack(failPurchaseCallBack);
			console.log(xconnection.getFailPurchaseCallBack());
			console.log(xconnection.getSuccessPurchaseCallBack());
			xconnection.setUserId(userId);
			
			var data = 'method=startPurchase&itemId=' + itemId + "&qty=" + itemQty + "&userId=" + userId;
			xconnection.callServer(data,function(data){
					
				if(data.error)
				{
					alert('error starting purchase flow');
				} else {
					xconnection.startDGFlow(data.redirecturl);
				}
			});
			
		},
		setSuccessPurchaseCallBack: function(newSuccessPurchaseCallBack) { this.successPurchaseCallBack = newSuccessPurchaseCallBack; },
		getSuccessPurchaseCallBack : function() {return this.successPurchaseCallBack; },
		setFailPurchaseCallBack: function(newFailPurchaseCallBack) { this.failPurchaseCallBack = newFailPurchaseCallBack; },
		getFailPurchaseCallBack : function() {return this.failPurchaseCallBack; },
		
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setUserId: function(newUserId) { userId = newUserId; },
		getUserId: function() { return userId; },
		
		verifyPurchase: function(itemId,verifyCallBack){
			var userId = xconnection.getUserId();
			data = localStorage.getItem(userId);
			
			xconnection.callServer('method=verifyPurchase&userId=' + userId + '&transactions=' + data + '&itemId=' + itemId,function(data){
				
				if(data.success)
				{
					console.log(data.details['PAYMENTSTATUS']);
					console.log(data);
					if(typeof verifyCallBack == 'function'){
						verifyCallBack.call(data);
					}
					
				} else {
					alert('Error: ' + data.error);
				}
			});
		},
		
		startDGFlow : function(url) {	
			dg.startFlow(url);
		},
		
		releaseDG : function(data) {
		
			if(data != undefined) {	
				if(xconnection.check_for_html5_storage)
				{
					var dataArray = JSON.parse(localStorage.getItem(xconnection.getUserId()));
					
					if(dataArray === null)
					{
						var dataArray = new Array();
						dataArray.push(data);
					} else {
						dataArray.push(data);
					}
					
					localStorage.setItem(xconnection.getUserId(), JSON.stringify(dataArray));
					
					xconnection.getSuccessPurchaseCallBack().call();
				}
			} else {	
				xconnection.getFailPurchaseCallBack().call();	
			}
			
			dg.closeFlow();
			
		},
		
		check_for_html5_storage: function() {
		  try {
			return 'localStorage' in window && window['localStorage'] !== null;
		  } catch (e) {
			return false;
		  }
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

