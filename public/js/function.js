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

  var initFSMap = function(markers) {
    var fs_map = L.map('fs-map').setView([lat, lon], 14);
    L.mapbox.tileLayer('alexnorton.h2hfjmmo', {detectRetina: true}).addTo(fs_map);

    $.each(markers, function(index, value) {
      L.marker(value, { 
        bounceOnAdd: true
      }).addTo(fs_map);
    });
  };

  getLocation();

  /***********
  ADDING CARDS
  ***********/

  var renderCards = function() {
    addFourSquareCard();
    addTrafficCard();
    addWeatherCard();
  };

  var addNewCard = function(html) {
    var after;
    if ($('#card').length > 0) {
      after = $('div[id=card]').last();
    } else {
      after = $('#map_wrapper');
    }

    $(after).after(html);
  };

  var addFourSquareCard = function() {
    var url = '/foursquare.json?lat=' + lat + '&long=' + lon

    $.getJSON(url, function(data) {
      var places = data.response.groups[0].items;
      var content = '<div class="row" id="card"><div class="col-md-offset-4 col-md-4 col-xs-offset-1 col-xs-10 card"><h2>Places of interest nearby</h2><ul>'

      var markers = [];

      for(var i = 0; i < 5; i++) {
        content += '<li>' + places[i].venue.name + ' (' + places[i].venue.location.distance + 'm)</li>';

        var points = [places[i].venue.location.lat, places[i].venue.location.lng];
        markers.push(points)
      }

      content += '</ul><span class="type">Places Nearby</span><span class="map_link"><span class="glyphicon glyphicon-chevron-down"></span></span></div>';

      content += '<div id="fs-map-toggle" class="col-md-offset-4 col-md-4 col-xs-offset-1 col-xs-10"><div id="fs-map"></div></div></div>';

      addNewCard(content);
      initFSMap(markers);
    });
  };

  var addTrafficCard = function() {
    var url = '/journey_times/nerarby_routes?lat=' + lat + '&long=' + lon + '&radius=10'
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-4 col-md-4 col-xs-offset-1 col-xs-10 card"><h2><b>' + data.length + '</b> traffic reports nearby</h2><ul>'
      
      for(var i = 0; i < data.length; i++) {

        if(data[i].severity == "clear") {
            colour = "rgb(26, 140, 216)"; 
        }
        else if(data[i].severity == "normal") {
          colour = "rgb(50, 162, 35)";
        }
        else if(data[i].severity == "moderate") {
          colour = "rgb(248, 186, 55)";
        }
        else if(data[i].severity == "severe") {
          colour = "rgb(241, 40, 12)";
        }
        


        content += '<li style="border-left: 15px solid ' + colour + '">' + data[i].description + '</li>';
    };

      content += '</ul><span class="type">Traffic</span><span class="map_link"><span class="glyphicon glyphicon-chevron-down"></span></span></div></div>';

      addNewCard(content);
    });
  };

  var addWeatherCard = function() {
    var url = 'weather/nearby_weather?lat=' + lat + '&long=' + lon
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-4 col-md-4 col-xs-offset-1 col-xs-10 card"><h2><b></b> Local weather</h2><ul>'
      
      
      content += '<li>Now: ' + data.current_summary + ' - ' + data.current_temp + ', feels like ' + data.currently_feels_like + '</li>'; 
      content += '<li>Later: ' + data.next_summary + ' - ' + data.next_temp + '</li>';
      
      content += '</ul><span class="type">Weather</span><span class="map_link"><span class="glyphicon glyphicon-chevron-down"></span></span></div></div>';

      addNewCard(content);
    });
  };

  /********
  LISTENERS
  ********/

  // Animate expanding the map
  $('#map_btn').click(function() {
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

  $('#fs-map-toggle').click(function() {
    console.log("click");
  });
});
