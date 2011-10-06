// JavaScript Document

var dg = new PAYPAL.apps.DGFlow({});

var pptransact = function(url) {
	var languageCenters = {"php": "server/php/pptransact.php",
						   "cf": "server/coldfusion/xconnect.cfc"};
	var url;
	
	return{
		init: function(language){
			this.url = (languageCenters['language']) ?
			            languageCenters['language'].toLowerCase :
				        languageCenters['php'];
			pptransact.setUserId(0);
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		
		bill: function(userId,itemId,itemQty,successBillCallBack,failBillCallBack){
			pptransact.setUserId(userId);
			pptransact.setSuccessBillCallBack(successBillCallBack);
			pptransact.setFailBillCallBack(failBillCallBack);
			
			var data = 'method=getToken&itemId=' + itemId + "&qty=" + itemQty + "&userId=" + userId;
			pptransact.callServer(data,function(data){
					
				if(data.error){
					alert('error starting bill flow');
				} else {
					pptransact.startDGFlow(data.redirecturl);
				}
			});
			
		},
		setSuccessBillCallBack: function(newSuccessBillCallBack) { this.successBillCallBack = newSuccessBillCallBack; },
		getSuccessBillCallBack : function() {return this.successBillCallBack; },
		setFailBillCallBack: function(newFailBillCallBack) { this.failBillCallBack = newFailBillCallBack; },
		getFailBillCallBack : function() {return this.failBillCallBack; },
		
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setUserId: function(newUserId) { userId = newUserId; },
		getUserId: function() { return userId; },
		
		setVerifyData: function(newVerifyData) { verifyData = newVerifyData; },
		getVerifyData: function() { return verifyData; },
		
		verify: function(userId,itemId,successVerifyCallBack,failVerifyCallBack){
			pptransact.setUserId(userId);
			data = localStorage.getItem(userId);
			
			pptransact.callServer('method=verifyPayment&userId=' + userId + '&transactions=' + data + '&itemId=' + itemId,function(data){
				
				pptransact.setVerifyData(data);
					
				if(data.success){
					if(pptransact.check_for_html5_storage){
						var dataArray = JSON.parse(localStorage.getItem(pptransact.getUserId()));
						
						if(dataArray !== null){
							for (var i = 0; i < dataArray.length; i++) {
								if(data.transactionId = dataArray[i].transactionId){
									dataArray.splice(i,1,data);
									localStorage.setItem(pptransact.getUserId(), JSON.stringify(dataArray));
								} 
							}
						}
					}
					
					if(typeof successVerifyCallBack == 'function'){
						successVerifyCallBack.call();
					}
					
				} else {
					if(typeof failVerifyCallBack == 'function'){
						failVerifyCallBack.call();
					}
				}
			});
		},
		
		startDGFlow : function(url) {	
			dg.startFlow(url);
		},
		
		releaseDG : function(data) {
		
			if(data != undefined) {	
				if(pptransact.check_for_html5_storage){
					var dataArray = JSON.parse(localStorage.getItem(pptransact.getUserId()));
					
					if(dataArray === null){
						var dataArray = new Array();
						dataArray.push(data);
					} else {
						
						/*for (var i = 0; i < dataArray.length; i++) {
							console.log(dataArray[i]);
						}*/
				
						
						dataArray.push(data);
					}
					
					localStorage.setItem(pptransact.getUserId(), JSON.stringify(dataArray));
					
					pptransact.getSuccessBillCallBack().call();
				}
			} else {	
				pptransact.getFailBillCallBack().call();	
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
				url: pptransact.getUrl(),
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

