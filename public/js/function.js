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
    map = L.map('map', {scrollWheelZoom: false}).setView([lat, lon], 14);

    L.mapbox.tileLayer('alexnorton.h2hfjmmo', {detectRetina: true}).addTo(map);

    L.marker([lat, lon], { 
      bounceOnAdd: true
    }).addTo(map);

    $('#map_btn').show();
    $('#map').css('border-style', 'solid');

    addPredictionCard();
  };

  var initFSMap = function(markers) {
    var fs_map = L.map('fs_map', {scrollWheelZoom: false}).setView([lat, lon], 14);
    L.mapbox.tileLayer('alexnorton.h2hfjmmo', {detectRetina: true}).addTo(fs_map);

    var colors = ['red', 'darkred', 'orange', 'green', 'darkgreen', 'blue', 'purple', 'darkpuple', 'cadetblue'];

    var icon_lookup = {
      'Pub': 'beer',
      'Plaza': 'leaf',
      'Café': 'coffee',
      'Fast Food': 'cutlery',
      'Grocery Store': 'shopping-cart',
      'Performing Arts': 'pencil',
      'Theater': 'smile-o'
    }

      var markerLayers = [];

    $.each(markers, function(index, value) {
      var color = colors[Math.floor(Math.random() * colors.length)];

      var redMarker = L.AwesomeMarkers.icon({
        icon: icon_lookup[value.icon],
        prefix: 'fa',
        markerColor: color
      });

      var marker = L.marker(value.points, {icon: redMarker}, { 
        bounceOnAdd: true
      });
      marker.bindPopup(value.text);

        markerLayers.push(marker);
      });

      var markerLayerGroup = new L.FeatureGroup(markerLayers);
      markerLayerGroup.addTo(fs_map);
      fs_map.fitBounds(markerLayerGroup.getBounds());
  };

  getLocation();

  /***********
  ADDING CARDS
  ***********/

  var renderCards = function() {
    addTrafficCard();
    addWeatherCard();
    addFourSquareCard();
    addRoadWorksCard();
  };

  var addNewCard = function(html) {
    $('div[id=card]').last().after(html);
  };

  var addFourSquareCard = function() {
    var url = '/foursquare.json?lat=' + lat + '&long=' + lon

    $.getJSON(url, function(data) {
      var places = data.response.groups[0].items;
      var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card"><h2>Places of interest nearby</h2><ul>'

      var markers = [];

      for(var i = 0; i < 5; i++) {
        var url = 'https://foursquare.com/v/' + places[i].venue.id
        content += '<li><a href="' + url + '"target="_blank">' + places[i].venue.name + ' (' + places[i].venue.location.distance + 'm)</a></li>';

        var points = [places[i].venue.location.lat, places[i].venue.location.lng];
        markers.push({
          'points': points,
          'text' : places[i].venue.name,
          'icon': places[i].venue.categories[0].shortName
        })
      }

      content += '</ul><span class="type">Places Nearby</span></div>';

      content += '<div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10"><div id="fs_map"></div></div></div>';

      addNewCard(content);
      initFSMap(markers);
    });
  };

  var addTrafficCard = function() {
    var url = '/journey_times/nerarby_routes?lat=' + lat + '&long=' + lon + '&radius=10'
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card"><h2><b>' + data.length + '</b> traffic reports nearby</h2><ul>'

      if(data[0] && data[0] > 0) {
          addMusicCard(data[0].ratio);
      } else {
          setTimeout(function() {
            addMusicCard(1);
          } 
           ,500);
          
      }

      for(var i = 0; i < data.length; i++) {

        if(data[i].severity == "clear") {
          border_colour = "rgb(26, 140, 216)"; 
        }
        else if(data[i].severity == "normal") {
          border_colour = "rgb(50, 162, 35)";
        }
        else if(data[i].severity == "moderate") {
          border_colour = "rgb(248, 186, 55)";
        }
        else if(data[i].severity == "severe") {
          border_colour = "rgb(241, 40, 12)";
        }
        
        content += '<li style="border-left: 15px solid ' + border_colour + '">' + data[i].description + ' <span style="color: ' + border_colour  + '"> (' + data[i].difference + 's)</span></li>';
      };

      content += '</ul><span class="type">Traffic</span></div></div>';

      addNewCard(content);
      addRoadWorksCard();
    });
    
  };

  var addWeatherCard = function() {
    var url = 'weather/nearby_weather?lat=' + lat + '&long=' + lon
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card"><h2>Local weather</h2><ul>'
      
      
      content += '<li>Now: ' + data.current_summary + ' - ' + data.current_temp + '&deg;C, feels like ' + data.currently_feels_like + '&deg;C</li>'; 
      content += '<li>Later: ' + data.next_summary + ' - ' + data.next_temp + '&deg;C</li>';
      
      content += '</ul><span class="type">Weather</span></div></div>';

      addNewCard(content);
      addTrafficCard();
    });
  };

  var addRoadWorksCard = function() {
    var url = '/roadworks/neraby_roadworks?lat=' + lat + '&long=' + lon + '&radius=10'
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card"><h2>' + data.length + ' road works nearby</h2><ul>'
      var border_colour;

      for(var i = 0; i < data.length; i++) {
        if(data[i].impact == "freeFlow") {
          border_colour = "rgb(50, 162, 35)";
        }
        else if(data[i].impact == "heavy") {
          border_colour = "rgb(248, 186, 55)";
        }
        else if(data[i].impact == "impossible") {
          border_colour = "rgb(241, 40, 12)";
        }

        var parts = data[i].comment.split('.');
        content += '<li style="border-left: 15px solid ' + border_colour + '">' + parts[0] + '</li>';
      };
      
      content += '</ul><span class="type">Road Works</span></div></div>';

      addNewCard(content);
      addFourSquareCard();
    });
   
  };

  var addMusicCard = function(severity) {
      var embed = '<iframe src="https://embed.spotify.com/?uri=spotify:trackset:PREFEREDTITLE:TRACKS" frameborder="0" allowtransparency="true"></iframe>';

      console.log(severity);
      var value = ((severity - 1) * 5) + 0.5;
      console.log(value);

      $.getJSON('/music/playlist.json', {
          speed: value,
          energy: value,
          danceability: 1
      }, function(data) {

          var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card music-card"><h2>Spotify playlist</h2>';

          if ('songs' in data.response) {
              var tracks = []
              data.response.songs.forEach(function(song) {
                  if(song.tracks.length > 0) {
                      tracks.push(song.tracks[0].foreign_id.replace('spotify-WW:track:', ''));
                  }
              });
              var tembed = embed.replace('TRACKS', tracks.join()).replace('PREFEREDTITLE', 'Playlist');

              content += '<ul style="padding-top: 10px;">' + tembed + '</ul>';

              $("#results").html(tembed);
          }

          content += '<span class="type">Music</span></div>';

          addNewCard(content);
      });
  };

  var addPredictionCard = function() {
    var url = '/prediction.json?lat=' + lat + '&long=' + lon + '&radius=10'
    $.getJSON(url, function(data) {
      var content = '<div class="row" id="card"><div class="col-md-offset-2 col-md-8 col-xs-offset-1 col-xs-10 card"><h2 style="margin-bottom:20px;">' + data.description + '</h2><span class="type">Travel Prediction</span></div></div>'

      $('#map_wrapper').after(content);

      addWeatherCard();
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
});
