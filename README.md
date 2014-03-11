<p align="center">
	<img src="https://raw.github.com/cfoxleyevans/HackSmart14/master/public/images/logo.png"/>
</p>

# Roadie

This is Roadie, Team Syn-Energy's entry to [Hack Smart Streets 2014](https://www.eventbrite.co.uk/e/hack-smart-streets-2014-tickets-10537266247).

Roadie is a road transport dashboard, designed to aid decision making by providing contextually relevant transport information, presented using a card based interface.

### Cards
- map of the user's current location
- prediction model taking into account road and weather conditions
- local weather
- nearby traffic reports
- nearby instances of roadworks
- places of interest in the vicinity (with map)
- dynamically generated spotify playlist based on current road conditions

### APIs and services used
- [Smart Streets England Current Road Works](https://smartstreets.sensetecnic.com/wotkit/sensors/42602/monitor)
- [Smart Streets UK  Traffic Travel Time](https://smartstreets.sensetecnic.com/wotkit/sensors/42598/monitor)
- [Mapbox.js](https://www.mapbox.com/mapbox.js/api/v1.6.2/)
- [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/)
- [Forecast.io API](https://developer.forecast.io/)
- [Foursquare API](https://developer.foursquare.com/)
- [Echo Nest API](http://developer.echonest.com/docs/v4)
- [Spotify Widget API](https://developer.spotify.com/technologies/widgets/)

### Usage

	git clone git@github.com:cfoxleyevans/HackSmart14.git
    bundle install
    bundle exec ruby lib/data_test.rb
    bundle exec rackup
    
### Authors
- [Alex Norton](https://github.com/alexnorton)
- [Charlie Revett](https://github.com/charlierevett)
- [Chris Foxley-Evans](https://github.com/cfoxleyevans)

### Screenshot

<p align="center">
	<img src="https://raw.github.com/cfoxleyevans/HackSmart14/master/screenshot.png"/>
</p>
