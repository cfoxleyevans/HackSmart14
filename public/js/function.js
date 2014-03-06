$(function() {
  var lat, lon, map;

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
    lat = position.coords.latitude;
    lon = position.coords.longitude;

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

    L.mapbox.tileLayer('alexnorton.h2hfjmmo', {detectRetina: true}).addTo(map);

    L.marker([lat, lon], { 
      bounceOnAdd: true
    }).addTo(map);

    $('#map_btn').show();
    $('#map').css('border-style', 'solid');

    renderCards();
  };

  getLocation();

  /***********
  ADDING CARDS
  ***********/

  var renderCards = function() {
    addNewCard('Traffic looks great!', 'Traffic');
    addNewCard('Weather is fantastic!', 'Weather');
    addNewCard('No road works affecting your routes!', 'Road Works');
    addFourSquareCard();
  };

  var addNewCard = function(text, type) {
    var after;
    if ($('#card').length > 0) {
      after = $('div[id=card]').last();
    } else {
      after = $('#map_wrapper');
    }

    $(after).after('<div class="row" id="card"><div class="col-md-offset-4 col-md-4 col-xs-offset-1 col-xs-10 box"><p>' + text + '</p><span class="type">' + type + '</span></div></div>');
  };

  var addFourSquareCard = function() {
    $.getJSON('/foursquare.json?lat='+lat+'&long='+lon, function(data) {
      var places = data.response.groups[0].items;

      var content = '';

      for(var i = 0; i < 3; i++) {
        content += places[i].venue.name + "<br>";
      }

      addNewCard(content, 'Places nearby');
    });
  }

  /********
  LISTENERS
  ********/

  // Animate expanding the map
  $('#map_btn').click(function(){
    var height = $('#map').height();

    if (height > 170) {
      $('#map').css('height', '170px');
      $('#map_btn_wrapper').css('margin-top', '150px');
      $('#map_btn').addClass('glyphicon-chevron-down');
      $('#map_btn').removeClass('glyphicon-chevron-up');
      map.invalidateSize();
    } else {
      $('#map').css('height', '350px');
      $('#map_btn_wrapper').css('margin-top', '330px');
      $('#map_btn').addClass('glyphicon-chevron-up');
      $('#map_btn').removeClass('glyphicon-chevron-down');
      map.invalidateSize();
    }
  });
});
