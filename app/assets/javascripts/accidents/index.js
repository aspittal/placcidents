$(document).ready(function(){
	///////////////////////////////////////////////////////////////
	// VARIABLES AND INITIALIZATION
	///////////////////////////////////////////////////////////////

	// Variables!
	var currentYear = 1908;
	var minYear = 1908;
	var maxYear = 2014;
	var accidentColor = 'red';
	var accidentFillColor = '#f03';
	var accidentFillOpacity = 0.25;
	var minRadius = 2;
	var maxRadius = 25;
	// This will store our json object, we should find a way to cache this!
	var accidents;

	// Map Initialization and required globals
	var map = new L.Map('map');
	var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/47c86430e02146d78826552cd35576cf/27169/256/{z}/{x}/{y}.png';
	var cloudmadeAttrib =
	  'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade';
	var cloudmade = new L.TileLayer(
	      cloudmadeUrl, 
	      {minZoom: 1, maxZoom: 18, attribution: cloudmadeAttrib}
	);
	var yearDeathTotals = [];
	var yearLayerGroups = [];
	prepareMap();

	////////////////////////////////////////////////////////////////
	// EVENT HANDLERS
	////////////////////////////////////////////////////////////////

	$("#slider").slider({
		range: "min",
		value: currentYear,
		min: minYear,
		max: maxYear,
		step: 1, 
		slide: function(event, ui) {
			map.removeLayer(yearLayerGroups[currentYear-minYear]);
			map.addLayer(yearLayerGroups[ui.value-minYear]);	
			currentYear = ui.value;
			$('#currentYearText').html(currentYear);
			populateDeaths(currentYear);
		}
	});

	////////////////////////////////////////////////////////////////
	// FUNCTIONS
	////////////////////////////////////////////////////////////////

	// Sets up all of our data into layer groups using an ajax call
	function prepareMap() {
		// Setup our year dependant arrays for easier indexing
		for (i = minYear; i < maxYear + 1; i++) {
			// Default values
			yearLayerGroups.push(new L.LayerGroup());
			yearDeathTotals.push(0);
		}

		// Set up our initial map configuration
		var centered = new L.LatLng(0,0); // geographical point (longitude and latitude)
		map.setView(centered, 1).addLayer(cloudmade);

		//Make our ajax request
		$.ajax({	
			url: 'accidents.json',
			type: 'GET',
			async: false,
			success: function(accidents) {
				accidentData = accidents;

				$.each(accidents, function() {
					addLayer(this);
					saveFatalities(this);
				});
			}
		});

		// Use our default layer
		map.addLayer(yearLayerGroups[currentYear-minYear]);
		populateDeaths(minYear);
		$('#currentYearText').html(currentYear);
	}

	// Populates our death totals into human viewable form
	function populateDeaths(yearToShow) {
		$('#humanCounter').html(yearDeathTotals[yearToShow - minYear]);
	}

	// Adds a layer with the given accident data
	function addLayer(accident) {
		var accidentRadius = Math.min(Math.max(((accident.fatalities + accident.ground_fatalities) / 10), minRadius), maxRadius);
		
		accidentYear = accident.date.substr(0,4);

	  	yearLayerGroups[accidentYear-minYear].addLayer(
		  	new L.CircleMarker(
			  	new L.LatLng(accident.latitude, accident.longitude),
			  	{
				  	color: accidentColor,
					fillColor: accidentFillColor,
					fillOpacity: accidentFillOpacity,
					radius: accidentRadius 
				}
		  	).bindPopup(
  				accident.date + ' - ' + accident.location + '<br />DEATHS: ' + 
  				accident.fatalities + ' (' + accident.ground_fatalities + ')'
 		 	)
  		);
	}

	// Helps tally our year fatality totals
	function saveFatalities(accident) {
		accidentYear = accident.date.substr(0,4);
		yearDeathTotals[accidentYear - minYear] += accident.fatalities + accident.ground_fatalities;
	}
});
