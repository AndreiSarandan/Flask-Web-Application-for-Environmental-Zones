let map;
let geocoder;
let gmarkers = [];

// Replace with your OpenCage API key
const openCageApiKey = '41aca459d77c4fe28b72c6bbe73d2ba1';
const aqiApiKey = '82645b03feba4f3384606a8471f00510abc10c37';

async function initMap() {
    const cities = await getCitiesFromBackend(); // Fetch cities from backend
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5,
        center: { lat: 48.79, lng: 10.61 }, // Center of the map (you may adjust)
        disableDefaultUI: true
    });
    addMarkers(cities); // Pass fetched cities to addMarkers
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

function constructAddress(city) {
    // Implement your logic here to construct the address string from city data
    const address = city.city + ", " + city.country; // Example structure, modify as needed
    console.log("address :" + address)
    return address;
}

async function addMarkers(cities) {
    const promises = cities.map(async city => {
        const location = await geocodeWithOpenCage(constructAddress(city));
        if (location) {
            const aqi = await getAQI(location.lat, location.lng, city.name);
            createMarker(location, city.city, aqi);
        } else {
            console.log('Geocoding failed for:', city);
        }
    });

    await Promise.all(promises);
}

function geocodeWithOpenCage(address) {
    const url = `https://api.opencagedata.com/geocode/v1/json?q=${encodeURIComponent(address)}&key=${openCageApiKey}`;
    return fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.results && data.results.length > 0) {
                return data.results[0].geometry;
            }
            return null;
        })
        .catch(error => {
            console.error('OpenCage API error:', error);
            return null;
        });
}

async function getAQI(lat, lng, city) {
    const url = `https://api.waqi.info/feed/geo:${lat};${lng}/?token=${aqiApiKey}`;
    try {
        const response = await fetch(url);
        const data = await response.json();
        if (data.status === 'ok') {
            return data.data.aqi;
        } else {
            console.error('Error fetching AQI data:', data.data);
            return null;
        }
    } catch (error) {
        console.error('Error fetching AQI data:', error);
        return null;
    }
}
//original with default markers
function createMarker(location, city, aqi) {
    const marker = new google.maps.Marker({
        map: map,
        position: { lat: location.lat, lng: location.lng },
        title: `${city}: AQI ${aqi}`
    });

    const infoWindow = new google.maps.InfoWindow({
        content: `The current AQI for ${city} is ${aqi}`
    });

    marker.addListener('click', () => {
        infoWindow.open(map, marker);
    });

    gmarkers.push(marker);
}



// Load the Maps JavaScript API asynchronously
function loadScript() {
    const script = document.createElement('script');
    script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyDSrGZOUl7LV020hIPMv0WXyKemXGj0Vgk&callback=initMap';
    script.defer = true;
    document.head.appendChild(script);
}

window.onload = loadScript;
