let geocoder;
let gmarkers = [];
let mc;
// const image = '/static/images/marker3.png';


document.addEventListener("DOMContentLoaded", () => {
    // Access the API key from the global variable
    const WAQI_API_KEY = window.WAQI_API_KEY;
    const GOOGLE_API_KEY = window.WAQI_API_KEY;
    const OPEN_CAGE_API_KEY = window.WAQI_API_KEY;

    console.log("API Key for WAI:", WAQI_API_KEY);

});


async function initMap() {
    const cities = await getCitiesFromBackend(); // Fetch cities from backend
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5,
        center: { lat: 48.79, lng: 10.61 }, // Center of the map (you may adjust)
        disableDefaultUI: true
    });
    // geocoder = new google.maps.Geocoder();
    // mc = new MarkerClusterer(map, [], {}); // Assuming you have MarkerClusterer library loaded
    // addMarkers(cities); // Pass fetched cities to addMarkers
}

async function getCitiesFromBackend() {
    try {
        const response = await fetch('/cities'); // Assuming your backend provides cities at /cities endpoint
        const data = await response.json();
        return data.cities; // Assuming your backend returns cities in a JSON object with a key 'cities'
    } catch (error) {
        console.error('Error fetching cities:', error);
        return []; // Return an empty array if there's an error
    }
}

async function addMarkers(cities) {
    for (let i = 0; i < cities.length; i++) {
        await geocodeAddress(cities[i], i);
    }
}

function geocodeAddress(address, index) {
    geocoder.geocode({ 'address': address }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            var location = results[0].geometry.location;
            // var markerIcon = {
            //     url: image, // Example custom marker icon
            //     scaledSize: new google.maps.Size(32, 32) // Set the size of the marker icon
            // };
            var marker = new google.maps.Marker({
                map: map,
                position: location,
                // icon: markerIcon
            });
            gmarkers.push(marker);
            mc.addMarker(marker); // Add marker to MarkerClusterer
        } else {
            console.log('Geocode was not successful for the following reason: ' + status);
        }
    });
}

// Load the Maps JavaScript API asynchronously
function loadScript() {
    const script = document.createElement('script');
    script.src = 'https://maps.googleapis.com/maps/api/js?key=' + GOOGLE_API_KEY + '&callback=initMap';
    script.defer = true;
    document.head.appendChild(script);
}

window.onload = loadScript;