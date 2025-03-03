// var directionsService, directionsRenderer
function initMap() {
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
    // Add more form data to the formData string if needed

    // Set up the callback function to handle the response
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                console.log('Response from backend:', response);

                // Display the descriptions in the readonly textareas
                const originDescriptionOutput = document.getElementById('origin-description-output');
                originDescriptionOutput.value = `Origin City Name: ${response.origin_city_name || 'Not found'} \nOrigin City Description: ${response.origin_city_description || 'Not found'} \nOrigin City Fines: ${response.origin_city_fines || 'Not found'} \nOrigin City Required Pass: ${response.origin_city_required_pass || 'Not found'} \n`;

                const destinationDescriptionOutput = document.getElementById('destination-description-output');
                destinationDescriptionOutput.value = `Destination City Name: ${response.destination_city_name || 'Not found'}\nDestination City Description: ${response.destination_city_description || 'Not found'}\nDestination City Fines: ${response.destination_city_fines || 'Not found'}\nDestination City Required Pass: ${response.destination_city_required_pass || 'Not found'}\n`;


                // Display notification based on the response
                const notification = document.createElement('div');
                notification.textContent = response.notification;
                notification.classList.add('notification', response.notificationType);
                document.body.appendChild(notification);
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

function calculateDirections() {
    const origin = document.getElementById('street-origin').value;
    const destination = document.getElementById('street-destination').value;

    var request = {
        origin: origin,
        destination: destination,
        travelMode: 'DRIVING',
        disableDefaultUI: true

    };

    var directionsService = new google.maps.DirectionsService();
    var directionsRenderer = new google.maps.DirectionsRenderer();
    directionsRenderer.setMap(map);

    directionsService.route(request, function (response, status) {
        if (status == 'OK') {
            directionsRenderer.setDirections(response);
        } else {
            console.error('Error fetching directions:', status);
        }
    });
}