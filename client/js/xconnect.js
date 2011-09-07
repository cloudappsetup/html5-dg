// JavaScript Document

var dg = new PAYPAL.apps.DGFlow({});

/*
connection(url,data)
url = the server side connection script
data = the query string to call method or pass variables.
target = the id of the dom element you are targeting.
targetType = either canvas or div
*/



var xconnection = function(url, data, target) {
	var url, data, target, state, webToken;
	var xbutton = {x : "",
	               y : "",
				   height : "",
				   width : "",
				   frameColor : ""};
	
	return{
		init: function(url, data, target){
			this.url = url;
			this.data = data;
			this.target = target;
		},
		
		setUrl: function(newUrl) { this.url = newUrl; },
		getUrl: function() { return this.url; },
		setData: function(newData) { this.data = newData; },
		getData: function() { return this.data; },
		setTarget: function(newTarget) { this.target = newTarget; },
		getTarget: function() { return this.target; },
		
		connectResult: function(newConnData){
			setState(newConnData.state);
			setWebToken(newConnData.webToken);
		},
		setState: function(newState) { state = newState; },
		getState: function() { return state; },
		setWebToken: function(newWebToken) { webToken = newWebToken; },
		getWebToken: function() { return webToken; },
		
		xbutton: function(x, y, height, width, frameColor) {
			this.xbutton.x = x;
			this.xbutton.y = y;
			this.xbutton.height = height;
			this.xbutton.width = width;
			this.xbutton.frameColor = frameColor;
		},
		
		setX: function(newX) { this.xbutton.x = newX; },
		getX: function() { return this.xbutton.x; },
		setY: function(newY) { this.xbutton.y = newY; },
		getY: function() { return this.xbutton.y; },
			
		setHeight: function(newHeight) { this.xbutton.height = newHeight; },
		getHeight: function() { return this.xbutton.height; },
		setWidth: function(newWidth) { this.xbutton.width = newWidth; },
		getWidth: function() { return this.xbutton.width; },
			 
		setFrameColor: function(newFrameColor) { this.xbutton.frameColor = newFrameColor; },
		getFrameColor: function() { return this.xbutton.frameColor; },  
		
		xButtonDisplay: function(){
			var FRAME_COLOR_WHITE = "rgb(255, 255, 255)";
			var canvas = $("#mainCanvas").get(0);
			canvasContext = canvas.getContext('2d');
				
			myContainer.x = 350;
			myContainer.y = 250;
			myContainer.width = 180;
			myContainer.height = 100;
			myContainer.rgb = FRAME_COLOR_WHITE;
			drawButton(myContainer);
				
			var x = xconnection.getX();
			var y = xconnection.getY();
			var h = xconnection.getHeight();
			var w = xconnection.getWidth();
			console.log(x);
			var myButton = new Object();
			buttonObj.src = "https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif";
				
			buttonObj.onload = function(e) {
					
				canvasContext.drawImage(buttonObj, x,y, h, w);
			};
				
				
			return true;
		}
	}
	
}();

// CONNECT 
$.extend({
	connect : function(callbackFnk){
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


// BUTTONCREATE
$.extend({
	createButton : function(callbackFnk){
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
	
	var canvas = $("#mainCanvas").get(0);
	var context = canvas.getContext('2d')
	context.clearRect(0, 0, canvas.width, canvas.height);
	var w = canvas.width;
	canvas.width = 1;
	canvas.width = w;
	
	setGame();
		
	context.drawImage(backgroundImage, 0, 0);	
	
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



/*
function xButtonDisplay(x,y,h,w) {

	// Offer Container area
	myContainer.x = 350;
	myContainer.y = 250;
	myContainer.width = 180;
	myContainer.height = 100;
	myContainer.rgb = FRAME_COLOR_WHITE;
	drawButton(myContainer);
	
	// Hit Area 
	myButton.x = 375;
	myButton.y = 300;
	myButton.width = 130;
	myButton.height = 30;
	//myButton.rgb = BUTTON_COLOR_LIGHT;
	drawButton(myButton);
	
	buttonObj.src = "https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif";
	buttonObj.onload = function() {
		canvasContext.drawImage(buttonObj, 375,300, 130, 30);
	};
}
*/

function showBuyButton() {
	// Offer Container area
	myContainer.x = 350;
	myContainer.y = 250;
	myContainer.width = 180;
	myContainer.height = 100;
	myContainer.rgb = FRAME_COLOR_WHITE;
	drawButton(myContainer);
	
	// Hit Area 
	myButton.x = 375;
	myButton.y = 300;
	myButton.width = 130;
	myButton.height = 30;
	//myButton.rgb = BUTTON_COLOR_LIGHT;
	drawButton(myButton);
	
	buttonObj.src = "https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif";
	buttonObj.onload = function() {
		canvasContext.drawImage(buttonObj, 375,300, 130, 30);
	};
}


function drawButton(buttonObj)
{
	canvasContext.fillStyle = buttonObj.rgb;
	canvasContext.fillRect (buttonObj.x, buttonObj.y, buttonObj.width, buttonObj.height);
}

function clearItem(buttonObj)
{
	canvasContext.clearRect (buttonObj.x, buttonObj.y, buttonObj.width, buttonObj.height);
}

function checkIfInsideButtonCoordinates(buttonObj, mouseX, mouseY)
{
	if(((mouseX > buttonObj.x) && (mouseX < (buttonObj.x + buttonObj.width))) && ((mouseY > buttonObj.y) && (mouseY < (buttonObj.y + buttonObj.height))))
		return true;
	else
		return false;
}


$(function() {
	
	$('#connect').click(function() {	
		$.connect(function(data){
			xconn.connectResult(data);
			console.log(testButton.xButtonDisplay()  );
		});
	});
	
	$('#createButton').click(function() {	
		xconn.setData('method=createButton');
		$.createButton(function(data){
		
			xconn.connectResult(data);
			showBuyButton();
		});
	});
	

	$("#" + xconnection.getTarget()).click(function(eventObject) {
		
		mouseX = eventObject.pageX - this.offsetLeft;
		mouseY = eventObject.pageY - this.offsetTop;

		if(checkIfInsideButtonCoordinates(myButton, mouseX, mouseY))
		{
			//console.log('hit area');
			
			xconn.setData('method=setExpressCheckout');
			$.setExpressCheckout(function(data){
				console.log(data.redirecturl);
				dg.startFlow(data.redirecturl);
			});
		}
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