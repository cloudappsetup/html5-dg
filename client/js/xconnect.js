// JavaScript Document

var session;

var dg = new PAYPAL.apps.DGFlow({});

// CONNECT 
$.extend({
	connect : function(args, callbackFnk){
		var currURL = args.url;
		var currData = args.data;
		$.ajax({
			url: currURL,
			data: currData,
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
	createButton : function(args, callbackFnk){
		var currURL = args.url;
		var currData = args.data;
		$.ajax({
			url: currURL,
			data: currData,
			success: function(data){
				var obj = $.parseJSON(data);
				
				if(typeof callbackFnk == 'function'){
					callbackFnk.call(this, obj);
				}
			}
		});	
	}
	
});


				

// GENERATE BUTTON
$.extend({
	generateButton : function(args){
		var currURL = args.url;
		var currData = args.data;
		var currSession = args.session;
		var currTarget = args.target;
		
		var args = {'url':'/html5-dg/server/coldfusion/connect.cfc','data':'method=setExpressCheckout'};
			$.setExpressCheckout(args, function(data){
				// assign redirect url with token
				console.log(data.redirecturl);
				dg.startFlow(data.redirecturl);
				
				
				//This CODE is for using a DIV to display button not canvas.  Currently not used
				/*
				var buttonData = "<a href='" + data.redirecturl  +"' id='" + currSession.buttonId +"'><img src='https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif' border='0' /></a>";
				$(currTarget).html(buttonData);
				*/
				
				
			});
			
			
			// This CODE is for using a DIV to display button not canvas.  Currently not used
			/*
		var buttonData = "<a href='http://www.google.com' id='" + currSession.buttonId +"'><img src='https://www.sandbox.paypal.com/en_US/i/btn/btn_buynow_LG.gif' border='0' /></a>";
		
		
		$(currTarget).html(buttonData);
		
		var dg = new PAYPAL.apps.DGFlow({
		// the HTML ID of the form submit button which calls setEC
			trigger: currSession.buttonId
		});
		*/
		
		/*
		$('#' +  currSession.buttonId).live('click', function() {	
			//alert('Set Express Checkout ' +  currSession.buttonId);
			var args = {'url':'/html5-dg/connect.cfc','data':'method=setExpressCheckout'};
			$.setExpressCheckout(args, function(data){
				// assign connection data to global session var
				console.log(data);
			});
		});
		*/
	}
});

// SETEXPRESSCHECKOUT
$.extend({
	setExpressCheckout : function(args, callbackFnk){
		var currURL = args.url;
		var currData = args.data;
		$.ajax({
			url: currURL,
			data: currData,
			success: function(data){
				var obj = $.parseJSON(data);
				
				if(typeof callbackFnk == 'function'){
					callbackFnk.call(this, obj);
				}
			}
		});	
	}
});




$(document).ready(function() {
	
	$('#connect').click(function() {	
		var args = {'url':'/html5-dg/server/coldfusion/connect.cfc','data':'method=connect'};
		$.connect(args, function(data){
			// assign connection data to global session var
			session = data;
		});
	});
	

	
	
	$('#createButton').click(function() {	

		var args = {'url':'/html5-dg/server/coldfusion/connect.cfc','data':'method=createButton','target':'#MyButtonTarget','session':session};
		$.createButton(args, function(data){
			
			console.log(data);
			var args = {'url':'/html5-dg/server/coldfusion/connect.cfc','data':'method=createButton','target':'#MyButtonTarget','session':data};
			
			showBuyButton();
			
			/*$.generateButton(args, function(data){
				console.log(data);
			});
			*/
		});
		
	});
	
	
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
var BUTTON_COLOR_DARK = "rgb(0, 0, 255)";
var BUTTON_COLOR_LIGHT = "rgb(0, 0, 128)";
var FRAME_COLOR_WHITE = "rgb(255, 255, 255)";


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
	myButton.y = 295;
	myButton.width = 130;
	myButton.height = 40;
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

	$("#mainCanvas").click(function(eventObject) {
		mouseX = eventObject.pageX - this.offsetLeft;
		mouseY = eventObject.pageY - this.offsetTop;

		if(checkIfInsideButtonCoordinates(myButton, mouseX, mouseY))
		{
			
			console.log('hit area');
			
			var args = {
				'url':'/html5-dg/server/coldfusion/connect.cfc',
				'data':'method=createButton',
				'target':'#MyButtonTarget',
				'session':''};

		
				$.generateButton(args, function(data){
					console.log(data);
				});
		
		}
	});


	// Debug code for XY position of mouse remove later
	$("#mainCanvas").mousemove(function(eventObject) {
		mouseX = eventObject.pageX - this.offsetLeft;
		mouseY = eventObject.pageY - this.offsetTop;

		$("#mouseXYSpan").html("X: " + mouseX + "   Y: " + mouseY);
		
	});
});

