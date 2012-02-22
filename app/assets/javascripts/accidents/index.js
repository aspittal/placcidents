$(document).ready(function(){
	///////////////////////////////////////////////////////////////
	// VARIABLES AND INITIALIZATION
	///////////////////////////////////////////////////////////////

	// Variables!
	var currentYear = 1916;
	var minYear = 1916;
	var maxYear = 2012;
	var accidentColor = 'red';
	var accidentFillColor = '#f03';
	var accidentFillOpacity = 0.2;
	var minRadius = 2;
	var maxRadius = 25;

	// Map Initialization
	var map = new L.Map('map');
	var yearLayerGroups = [];
	var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/47c86430e02146d78826552cd35576cf/997/256/{z}/{x}/{y}.png';
	var cloudmadeAttrib =
	  'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade';
	var cloudmade = new L.TileLayer(
	      cloudmadeUrl, 
	      {minZoom: 1, maxZoom: 18, attribution: cloudmadeAttrib}
	);
	prepareMap();

	////////////////////////////////////////////////////////////////
	// EVENT HANDLERS
	////////////////////////////////////////////////////////////////

	$("#slider").slider({
		value: currentYear,
		min: minYear,
		max: maxYear,
		step: 1, 
		slide: function(event, ui) {
			map.removeLayer(yearLayerGroups[currentYear-minYear]);
			map.addLayer(yearLayerGroups[ui.value-minYear]);	
			currentYear = ui.value;
			$('#currentYearText').html(currentYear);
		}
	});

	////////////////////////////////////////////////////////////////
	// FUNCTIONS
	////////////////////////////////////////////////////////////////

	// Sets up all of our data into layer groups using ajax requests
	function prepareMap() {
		for (i = minYear; i < maxYear + 1; i++) {
			yearLayerGroups.push(new L.LayerGroup());
			$.ajax({	
				url: 'accidents.json',
				type: 'GET',
				async: false,
				data: 'year=' + i,
				success: function(accidents) {
					var centered = new L.LatLng(0,0); // geographical point (longitude and latitude)
					map.setView(centered, 1).addLayer(cloudmade);

					$.each(accidents, function() {
						var accidentRadius = Math.min(Math.max(((this.fatalities + this.ground_fatalities) / 10), minRadius), maxRadius);
						
					  	yearLayerGroups[i-minYear].addLayer(
						  	new L.CircleMarker(
							  	new L.LatLng(this.latitude, this.longitude),
							  	{
								  	color: accidentColor,
									fillColor: accidentFillColor,
									fillOpacity: accidentFillOpacity,
									radius: accidentRadius 
								}
						  	).bindPopup(
				  				this.date + ' - ' + this.location + '<br />DEATHS: ' + 
				  				this.fatalities + ' (' + this.ground_fatalities + ')'
				 		 	)
				  		);
					});
				}
			});
		}
		map.addLayer(yearLayerGroups[0]);
		$('#currentYearText').html(currentYear);
	}
});
