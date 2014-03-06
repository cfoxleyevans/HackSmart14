$(function() {
  /******
  GLOBALS
  ******/

  var map;

  /*******************
  LOCATION AND MAPPING
  *******************/

  // Use HTML5 GeoLocation to get lat/long
  var getLocation = function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(getAddress);
    } else {
      updateLocationField('Geolocation not supported...');
    }
  };

  // Use GoogleMaps API to get nearest address for lat/long
  var getAddress = function(position) {
    var lat = position.coords.latitude;
    var lon = position.coords.longitude;

    initLeafletMap(lat, lon);

    var maps_url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lon +"&sensor=true";

    $.get(maps_url, function(data) {
      var parts   = data.results[0].address_components.slice(0,4);

      var address = "";
      $.each(parts, function(index, value) {
        if (index === 0) {
          address += value.short_name;  
        } else {
          address += ", " + value.short_name;
        }
      });

      updateLocationField(address);
    })
    .fail(function() {
      updateLocationField('Cannot get location...');
    });
  };

  // Update 'location' field in UI
  var updateLocationField = function(text) {
    $('#location').html('<p>' + text + '</p>');
  };

  // Create Leaflet Map centered at user's location
  var initLeafletMap = function(lat, lon) {
    map = L.map('map').setView([lat, lon], 14);

    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 18
    }).addTo(map);

    L.marker([lat, lon], { 
      bounceOnAdd: true
    }).addTo(map);

    $('#map_btn').show();
  };

  getLocation();

  /********
  LISTENERS
  ********/

  // Animate expanding the map
  $('#map_btn').click(function(){
    var height = $('#map').height();

    if (height > 180) {
      $('#map').animate({height:180},200);
      $('#map_btn_wrapper').animate({"margin-top":170},200);
      $('#map_btn').addClass('glyphicon-chevron-down');
      $('#map_btn').removeClass('glyphicon-chevron-up');
    } else {
      $('#map').animate({height:360},200);
      $('#map_btn_wrapper').animate({"margin-top":350},200);
      $('#map_btn').addClass('glyphicon-chevron-up');
      $('#map_btn').removeClass('glyphicon-chevron-down');
    }
  });
});
