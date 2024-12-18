let map;
let gmarkers = [];
let mc;

async function initMap() {
    const cities = await getCitiesFromBackend(); // Fetch cities from backend
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5,
        center: { lat: 48.79, lng: 10.61 }, // Center of the map (you may adjust)
        disableDefaultUI: true
    });

    // Assuming you have MarkerClusterer library loaded
    mc = new MarkerClusterer(map, gmarkers, { imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m' });

    cities.forEach(async function (city) {
        const aqi = await getAQIData(city);
        // Only display marker if AQI data is available
        if (aqi !== undefined) {
            addMarker(city, aqi);
        }
    });
}


async function getCitiesFromBackend() {
    try {
        const response = await fetch('/cities');
        const data = await response.json();
        return data.cities; // Assuming your backend returns cities in a JSON object with a key 'cities'
    } catch (error) {
        console.error('Error fetching cities:', error);
        return []; // Return an empty array if there's an error
    }
}

function addMarker(city, aqi) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': city }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            var iconColor = getAQIColor(aqi);
            var marker = new google.maps.Marker({
                map: map,
                position: results[0].geometry.location,
                label: String(aqi),
                title: city + ': AQI ' + aqi,
                icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    fillColor: iconColor,
                    fillOpacity: 0.8,
                    strokeWeight: 0,
                    scale: 10
                }
            });
            gmarkers.push(marker);
            mc.addMarker(marker); // If using MarkerClusterer
        } else {
            console.error('Geocode was not successful for the following reason: ' + status);
        }
    });
}

function getAQIColor(aqi) {
    if (aqi <= 50) return 'green';
    if (aqi <= 100) return 'yellow';
    if (aqi <= 150) return 'orange';
    if (aqi <= 200) return 'red';
    return 'purple';
}

function getAQIData(city) {
    var apiUrl = 'https://api.waqi.info/feed/' + encodeURIComponent(city) + '/?token=82645b03feba4f3384606a8471f00510abc10c37';
    return fetch(apiUrl)
        .then(response => response.json())
        .then(data => data.data.aqi)
        .catch(error => {
            console.error('Error fetching AQI data:', error);
            return undefined;
        });
}

//82645b03feba4f3384606a8471f00510abc10c37
