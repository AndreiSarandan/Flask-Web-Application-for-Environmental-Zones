var directionsService, directionsRenderer, map, originAutocomplete, destinationAutocomplete;

// // Function to remove car element from the UI
// function removeCarElement(carId) {
//     const carElement = document.getElementById(`car-${carId}`);
//     if (carElement) {
//         carElement.remove();
//     }
// }

// // Function to remove a car using fetch API
// function removeCar(carId) {
//     // Send AJAX request to delete the car
//     fetch(`/delete-car/${carId}`, {
//         method: 'DELETE',
//     })
//         .then(response => {
//             if (!response.ok) {
//                 throw new Error('Failed to delete car');
//             }
//             // Reload the page after successful deletion
//             location.reload();
//         })
//         .catch(error => {
//             console.error('Error removing car:', error);
//         });
// }



// $(document).ready(function () {
//     // Attach click event listener to delete buttons
//     $('.delete-btn').click(function () {
//         // Get car ID from data attribute
//         var carId = $(this).data('car-id');

//         // Send AJAX request to delete car
//         $.ajax({
//             url: '/delete_car',  // URL to your delete car route
//             type: 'POST',
//             data: { car_id: carId },
//             success: function (response) {
//                 // Remove deleted car item from the DOM
//                 removeCarElement(carId);
//             },
//             error: function (xhr, status, error) {
//                 console.error('Error deleting car:', error);
//             }
//         });
//     });
// });



function onOriginChanged() {
    var place = originStreetAutocomplete.getPlace();

    if (!place.geometry) {
        document.getElementById('street-origin').placeholder = 'Enter a place: ';
    } else {
        // Extracting information
        var street = place.name;
        var locality = place.address_components.find(c => c.types.includes('locality'))?.long_name || '';
        var country = place.address_components.find(c => c.types.includes('country'))?.long_name || '';

        // Displaying information (you can modify this part based on your needs)
        console.log('Street: ' + street);
        console.log('Locality: ' + locality);
        console.log('Country: ' + country);

        document.getElementById("city-origin").value = locality;
        document.getElementById("country-origin").value = country;


        var detailsElement = document.getElementById('details');
        if (detailsElement) {
            detailsElement.innerHTML = 'Street: ' + street + '<br>Locality: ' + locality + '<br>Country: ' + country;
        }
    }
}

function onDestinationChanged() {
    var place = destinationStreetAutocomplete.getPlace();

    if (!place.geometry) {
        document.getElementById('street-destination').placeholder = 'Enter a place: ';
    } else {
        // Extracting information
        var street = place.name;
        var locality = place.address_components.find(c => c.types.includes('locality'))?.long_name || '';
        var country = place.address_components.find(c => c.types.includes('country'))?.long_name || '';

        // Displaying information (you can modify this part based on your needs)
        console.log('Street: ' + street);
        console.log('Locality: ' + locality);
        console.log('Country: ' + country);

        document.getElementById("city-destination").value = locality;
        document.getElementById("country-destination").value = country;

        // You can also update some HTML elements with the extracted information
        var detailsElement = document.getElementById('details');
        if (detailsElement) {
            detailsElement.innerHTML = 'Street: ' + street + '<br>Locality: ' + locality + '<br>Country: ' + country;
        }
    }
}


function initMap() {
    directionsService = new google.maps.DirectionsService();
    directionsRenderer = new google.maps.DirectionsRenderer();
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 6,
        center: { lat: 51.509865, lng: -0.118092 }
    });
    directionsRenderer.setMap(map);

    originStreetAutocomplete = new google.maps.places.Autocomplete(
        document.getElementById('street-origin'),
        { types: ['geocode', 'establishment'] }
    );
    originStreetAutocomplete.addListener('place_changed', onOriginChanged);



    destinationStreetAutocomplete = new google.maps.places.Autocomplete(
        document.getElementById('street-destination'),
        { types: ['geocode', 'establishment'] }
    );
    destinationStreetAutocomplete.addListener('place_changed', onDestinationChanged);

}

function calculateDirections() {
    const origin = document.getElementById('street-origin').value;
    const destination = document.getElementById('street-destination').value;

    var request = {
        origin: origin,
        destination: destination,
        travelMode: 'DRIVING'
    };

    directionsService.route(request, function (response, status) {
        if (status == 'OK') {
            directionsRenderer.setDirections(response);
        } else {
            console.error('Error fetching directions:', status);
        }
    });
}


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