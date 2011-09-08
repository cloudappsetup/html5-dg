// JavaScript Document

//var dg = new PAYPAL.apps.DGFlow({});
var dg;
/*
connection(url,data)
url = the server side connection script
data = the query string to call method or pass variables.
target = the id of the dom element you are targeting.
targetType = either canvas or div
*/



var xconnection = function(url, target) {
	var url, target, state, webToken;
	var xbutton = {x : "",
	               y : "",
				   height : "",
				   width : "",
				   frameColor : ""};
	
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
		
		xbutton: function(x, y, top, left) {
			this.xbutton.x = x;
			this.xbutton.y = y;
			this.xbutton.top = top;
			this.xbutton.left = left;
		},
		
		setTop: function(newTop) { this.xbutton.top = newTop; },
		getTop: function() { return this.xbutton.top; },
		setLeft: function(newY) { this.xbutton.top = newTop; },
		getLeft: function() { return this.xbutton.top; },
			
		setHeight: function(newHeight) { this.xbutton.height = newHeight; },
		getHeight: function() { return this.xbutton.height; },
		setWidth: function(newWidth) { this.xbutton.width = newWidth; },
		getWidth: function() { return this.xbutton.width; },
			 
		setFrameColor: function(newFrameColor) { this.xbutton.frameColor = newFrameColor; },
		getFrameColor: function() { return this.xbutton.frameColor; },  
		
		xButtonDisplay: function(){
			var top = xconnection.getTop();
			var left = xconnection.getLeft();
			var h = xconnection.getHeight();
			var w = xconnection.getWidth();
			
			console.log(w);
			$('#gameContainer').append(' <div id="xButtonContainer" style="background-color:#FFF; border-radius:8px; height:90px; position:absolute; display:block; width:200px; left:50px; top:300px; z-index:999999;"><a href="#" class="ppButton"><img  style="position:absolute;top:20px; left:50px;" src="https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif"/></div>');
			$('#xButtonContainer').width(w);
			$('#xButtonContainer').height(h);
			$('#xButtonContainer').css({ "left": top + "px"});
			$('#xButtonContainer').css({ "top": left + "px"});
			
			var buttonId;
			xconnection.callServer('method=createButton',function(data){
				buttonId = data.buttonId;
				$('#xButtonContainer .ppButton').attr('id',data.buttonId);
				xconnection.connectResult(data);
				
				dg = new PAYPAL.apps.DGFlow({
					trigger: data.buttonId
				});
				
				xconnection.callServer('method=setExpressCheckout',function(data){
					console.log(data);
					$('#' + buttonId).attr('href',data.redirecturl);
					
					
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



// BUTTONCREATE
$.extend({
	createButton : function(callbackFnk){
		$.ajax({
			url: xconn.getUrl(),
			data: 'method=createButton',
			success: function(data){
				var obj = $.parseJSON(data);
				
				if(typeof callbackFnk == 'function'){
					callbackFnk.call(this, obj);
				}
			}
		});	
	}
	
});


// SETEXPRESSCHECKOUT
$.extend({
	setExpressCheckout : function(callbackFnk){
		$.ajax({
			url: xconn.getUrl(),
			data: xconn.getData(),
			success: function(data){
				var obj = $.parseJSON(data);
				
				if(typeof callbackFnk == 'function'){
					callbackFnk.call(this, obj);
				}
			}
		});	
	}
});




function releaseDG() {
	
	parent.dg.closeFlow();
	
}




var canvasContext;
var myButton = new Object();
var myContainer = new Object();
var buttonObj = new Image();

var mouseX = 0;
var mouseY = 0;
var backgroundImage = new Image();
var FRAME_COLOR_DARK_BLUE = "rgb(0, 0, 255)";
var FRAME_COLOR_LIGHT_BLUE = "rgb(0, 0, 128)";




$(function() {
	
	
	$('#createButton').click(function() {	
	
		
		xconnection.xButtonDisplay();
	/*
		$.createButton(function(data){
			xconn.connectResult(data);
			showBuyButton();
		});
		*/;
	});
	

	$("#" + xconnection.getTarget()).click(function(eventObject) {
		
			xconn.setData('method=setExpressCheckout');
			$.setExpressCheckout(function(data){
				console.log(data.redirecturl);
				dg.startFlow(data.redirecturl);
			});
		
	});


	// Debug code for XY position of mouse remove later
	/*
	$("#mainCanvas").mousemove(function(eventObject) {
		mouseX = eventObject.pageX - this.offsetLeft;
		mouseY = eventObject.pageY - this.offsetTop;

		$("#mouseXYSpan").html("X: " + mouseX + "   Y: " + mouseY);
		
	});
	*/
});