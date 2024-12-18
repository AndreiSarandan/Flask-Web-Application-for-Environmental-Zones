// Function to fetch AQI data for a given city
function getAQIData(city) {
    var apiUrl = 'https://api.waqi.info/feed/' + city + '/?token=82645b03feba4f3384606a8471f00510abc10c37';
    return fetch(apiUrl)
        .then(response => response.json())
        .then(data => data.data.aqi)
        .catch(error => console.error('Error fetching AQI data:', error));
}

// Define your list of cities
var cities = ['Paris', 'Berlin', 'London', 'Bucharest', 'Budapest']; // Add your cities here

var map = new google.maps.Map(document.getElementById('map'), {
    center: new google.maps.LatLng(0, 0),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    zoom: 2
});

// Function to add markers to the map
function addMarker(city, aqi) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': city }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            // Set marker color based on AQI level
            var iconColor;
            if (aqi <= 50) {
                iconColor = 'green';
            } else if (aqi <= 100) {
                iconColor = 'yellow';
            } else if (aqi <= 150) {
                iconColor = 'orange';
            } else if (aqi <= 200) {
                iconColor = 'red';
            } else {
                iconColor = 'purple';
            }
            // Create marker with custom icon and title
            var marker = new google.maps.Marker({
                map: map,
                position: results[0].geometry.location,
                label: String(aqi), // Set marker label as AQI value
                title: city + ': AQI ' + aqi, // Include AQI value in title
                icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    fillColor: iconColor,
                    fillOpacity: 0.8,
                    strokeWeight: 0,
                    scale: 10
                }
            });
        } else {
            console.error('Geocode was not successful for the following reason: ' + status);
        }
    });
}

// Fetch AQI data for each city and add markers to the map
cities.forEach(function (city) {
    getAQIData(city)
        .then(function (aqi) {
            // Only display marker if AQI data is available
            if (aqi !== undefined) {
                addMarker(city, aqi);
            }
        });
});