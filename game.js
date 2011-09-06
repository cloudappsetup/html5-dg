// JavaScript Document

// This Code would be specific to the game developer
function setGame() {
	var canvas = $("#mainCanvas").get(0);
	canvasContext = canvas.getContext('2d');
	backgroundImage.src = "angrybirds.png";
	
	$(backgroundImage).load(function() {
		canvasContext.drawImage(backgroundImage, 0, 0);
	});
	  
}

$(function() {
	
	setGame();
	
});