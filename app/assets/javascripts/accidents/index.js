$(document).ready(function(){
	// Configure our leaflet map
	var map = new L.Map('map');
	var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/47c86430e02146d78826552cd35576cf/997/256/{z}/{x}/{y}.png';
	var cloudmadeAttrib =
	  'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade';
	var cloudmade = new L.TileLayer(
	      cloudmadeUrl, 
	      {minZoom: 2, maxZoom: 18, attribution: cloudmadeAttrib}
	);

	$.ajax({
		url: 'accidents.json',
		dataType: 'json',
		success: function(accidents) {
			var centered = new L.LatLng(51.505, -0.09); // geographical point (longitude and latitude)
			map.setView(centered, 2).addLayer(cloudmade);

			$.each(accidents, function() {
			  	map.addLayer(
				  	new L.CircleMarker(
					  	new L.LatLng(this.latitude, this.longitude),
					  	{color: 'red', fillColor: '#f03', fillOpacity: 0.2, radius: (this.fatalities + this.ground_fatalities)/50}
				  	).bindPopup(
		  				this.date + ' - ' + this.location + '<br />DEATHS: ' + 
		  				this.fatalities + ' (' + this.ground_fatalities + ')'
		 		 	)
		  		);
			})
		}
	});
});
