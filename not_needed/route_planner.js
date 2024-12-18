// var directionsService, directionsRenderer
var directionsRenderer, directionsService;

// Define a function to get AQI data
function getAQI(city) {
    var apiUrl = 'https://api.waqi.info/feed/' + city + '/?token=82645b03feba4f3384606a8471f00510abc10c37';
    return fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            console.log('aaaaaa', data.data.aqi);
            return data.data.aqi;
        })
        .catch(error => console.error('Error fetching AQI data:', error));
}


function initMap() {

    directionsService = new google.maps.DirectionsService();
    directionsRenderer = new google.maps.DirectionsRenderer();
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 6,
        center: { lat: 51.509865, lng: -0.118092 },
        disableDefaultUI: true

    });
    const originInput = document.getElementById("street-origin");
    const destinationInput = document.getElementById("street-destination");
    const countryOriginInput = document.getElementById("country-origin");
    const cityOriginInput = document.getElementById("city-origin");
    const countryDestinationInput = document.getElementById("country-destination");
    const cityDestinationInput = document.getElementById("city-destination");

    const originAutocomplete = new google.maps.places.Autocomplete(originInput);
    const destinationAutocomplete = new google.maps.places.Autocomplete(destinationInput);

    // Add listeners for when place is selected in origin and destination autocomplete
    originAutocomplete.addListener("place_changed", () => {
        const place = originAutocomplete.getPlace();
        if (!place.geometry || !place.geometry.location) {
            window.alert("No details available for input: '" + place.name + "'");
            return;
        }
        countryOriginInput.value = getComponent(place, 'country');
        cityOriginInput.value = getComponent(place, 'locality');
    });

    destinationAutocomplete.addListener("place_changed", () => {
        const place = destinationAutocomplete.getPlace();
        if (!place.geometry || !place.geometry.location) {
            window.alert("No details available for input: '" + place.name + "'");
            return;
        }
        countryDestinationInput.value = getComponent(place, 'country');
        cityDestinationInput.value = getComponent(place, 'locality');
    });
}

function getComponent(place, component) {
    for (var i = 0; i < place.address_components.length; i++) {
        for (var j = 0; j < place.address_components[i].types.length; j++) {
            if (place.address_components[i].types[j] === component) {
                return place.address_components[i].long_name;
            }
        }
    }
    return '';
}

document.addEventListener("DOMContentLoaded", function () {
    const script = document.createElement("script");
    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDSrGZOUl7LV020hIPMv0WXyKemXGj0Vgk&callback=initMap&libraries=places&v=weekly";
    script.async = true;
    script.defer = true;
    document.body.appendChild(script);
});
function handleFormSubmission() {
    // Get form data
    const origin = document.getElementById('street-origin').value;
    const destination = document.getElementById('street-destination').value;
    const originCity = document.getElementById('city-origin').value;
    const destinationCity = document.getElementById('city-destination').value;
    const selectedCar = document.getElementById('selected-car').value;
    const originCountry = document.getElementById('country-origin').value;
    const destinationCountry = document.getElementById('country-destination').value;

    // AJAX request to send data to backend
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/maps', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    // Define the data to be sent
    const formData = `street-origin=${encodeURIComponent(origin)}&city-origin=${encodeURIComponent(originCity)}&street-destination=${encodeURIComponent(destination)}&city-destination=${encodeURIComponent(destinationCity)}&selected-car=${encodeURIComponent(selectedCar)}&country-origin=${encodeURIComponent(originCountry)}&country-destination=${encodeURIComponent(destinationCountry)}`;

    // Set up the callback function to handle the response
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                console.log('Response from backend:', response);

                // Display the descriptions with full control
                displayDescription('origin', response);
                displayDescription('destination', response);
                toggleDescriptionVisibility();

            } else {
                console.error('Error from backend:', xhr.status);
            }
        }
    };

    // Send the request
    xhr.send(formData);

    // Update the map using the calculateDirections function or any other logic
    calculateDirections();
}
function displayDescription(type, response) {
    // Create breakline element
    var br = document.createElement('br');

    // Clear the content inside the anchor tag containers
    var aContainer = document.getElementById(`${type}-a-container`);
    while (aContainer.firstChild) {
        aContainer.removeChild(aContainer.firstChild);
    }

    const descriptionBox = document.getElementById(`${type}-description-output`);

    if (!response) {
        console.error('Response is undefined or null.');
        return;
    }

    const messageClass = getClassType(response[type + '_notification_type']);
    descriptionBox.className = messageClass; // SUCCESS or FAILED

    // Check if image already exists
    var img = document.getElementById(`${type}-image`);
    if (!img) {
        // Create new image element if it doesn't exist
        img = document.createElement("img");
        img.id = `${type}-image`; // Set image id
        img.classList.add("description-image"); // Add class for styling

        // Add event listener for error to handle cases where image loading fails
        img.addEventListener('error', function () {
            console.error('Image loading failed:', img.src);
            // You can handle the error here, e.g., by setting a placeholder image
            // img.src = 'path/to/placeholder-image.png';
        });

        // Append image to description box
        var src = document.getElementById(`${type}-description-box`);
        src.appendChild(img);
    }

    // Set image source based on message class
    if (messageClass === "success-description" || messageClass === "success-no-lez-description") {
        img.src = "static/images/happy_earth.png";
    } else if (messageClass === "error-description") {
        img.src = "static/images/sad_earth.png";
    }



    // Create description text
    var aqiValue;
    let descriptionText = '';
    descriptionText += `Low emission zone: ${response[type + '_city_name'] || 'Not found'}, ${response[type + '_country'] || 'Not found'} <br>`;
    descriptionText += `${response[type + '_notification_msg'] || 'Not found'}`; //add general message (can or cannot)

    // Depending on if the zone has a "sticker"/required pass in place or just euro standard is checked
    if (response[type + '_city_required_pass'] === "N/A")
        descriptionText += `${response[type + '_city__minimum_diesel_petrol'] || 'Not found'}  <br>`;
    else {
        descriptionText += `Entering this LEZ requires: ${response[type + '_city_required_pass'] || 'Not found'}  <br>`;
    }
    descriptionText += `Penalties for not complying with the regulations: ${response[type + '_city_fines'] || 'Not found'}  <br>`;

    getAQI(response[type + '_city_name']).then(aqiValue => {
        console.log('AQI VALUE dupa functie:', aqiValue);
        descriptionText += `Current Air Quality Index: ${aqiValue}  <br>`;
        descriptionBox.innerHTML = descriptionText;

    });
    // aqiValue = response[type + '_city_aqi']
    // descriptionText += `Current Air Quality Index: ${aqiValue} \n`;
    // descriptionBox.textContent = descriptionText;
    // descriptionText += `Current Air Quality Index: ${aqiValue} \n`;
    // Set description text content
    // descriptionBox.textContent = descriptionText;

    // Redirect to eligibility check
    var aTag1 = document.createElement('a');
    aTag1.classList.add("redirect-link");
    aTag1.setAttribute('href', '/eligibility-check');
    aTag1.innerText = "Click here to check your car's eligibility for registrations.    ";
    aContainer.appendChild(aTag1);
    aContainer.appendChild(br);

    // Redirect to official page
    var aTag2 = document.createElement('a');
    aTag2.classList.add("redirect-link");
    aTag2.setAttribute('href', `${response[type + '_city_official_page'] || 'Not found'}`);
    aTag2.innerText = "    Further information on the official page. ";
    aContainer.appendChild(aTag2);
}



function getClassType(notificationType) {
    // Define class types based on notification types from the backend
    switch (notificationType) {
        case 'error':
            return 'error-description';
        case 'success-no-lez':
            return 'success-no-lez-description';
        case 'success':
            return 'success-description';
        default:
            return 'default-description'; // Default class type
    }
}


function toggleDescriptionVisibility() {
    // Get references to the description text areas
    const originDescriptionOutput = document.getElementById('origin-description-output');
    const destinationDescriptionOutput = document.getElementById('destination-description-output');
    const descrptionBoxes = document.getElementById('hideable');

    // Make the description text areas visible
    originDescriptionOutput.style.display = 'block';
    destinationDescriptionOutput.style.display = 'block';
    descrptionBoxes.style.display = 'block';
}


function calculateDirections() {
    const origin = document.getElementById('street-origin').value;
    const destination = document.getElementById('street-destination').value;

    var request = {
        origin: origin,
        destination: destination,
        travelMode: 'DRIVING'
    };


    directionsRenderer.setMap(map);

    directionsService.route(request, function (response, status) {
        if (status == 'OK') {
            directionsRenderer.setDirections(response);
        } else {
            console.error('Error fetching directions:', status);
        }
    });
}