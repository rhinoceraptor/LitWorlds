function getVideo(element) {
	var xmlhttp;

	if(window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest();
	} else {
		xmlhttp = new ActiveObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if(xmlhttp.readyState == 4 && xmlhttp.status == 0) {
			document.getElementById("video").innerHTML = xmlhttp.responseText;
		} else if (xmlhttp.readyState == 4) {
			console.log("Error getting response");
			console.log(xmlhttp.responseText);
			console.log(xmlhttp.status);
		}
	}
	var request = element.value + ".html";
	xmlhttp.open("GET",request);
	xmlhttp.send();
}
function test(element) {
	document.getElementById("video").innerHTML =  element.value;
}