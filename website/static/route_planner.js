// var directionsService, directionsRenderer
var directionsRenderer, directionsService;
// Function to add a new city input field
function addField() {
    const container = document.getElementById('city-inputs-container');

    // Create a new city input
    const div = document.createElement("div");
    div.classList.add("elem-group", "inlined-big");
    const label = document.createElement("label");
    label.textContent = "CITY ADDRESS:";
    const input = document.createElement("input");
    input.classList.add("address_election", "city-input");
    input.type = "text";
    input.placeholder = "Enter city street";

    //delete button

    var deleteButtonDiv = document.createElement("div");
    deleteButtonDiv.classList.add("elem-group");
    deleteButtonDiv.classList.add("inlined-small"); // Add inlined-small class
    deleteButtonDiv.classList.add("route-planner-del-button"); // Add inlined-small class

    // Create delete button
    var deleteButton = document.createElement("button");
    deleteButton.className = "delete-minus-button-no-span";
    // deleteButton.innerHTML = `
    //     <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
    //         <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
    //     </svg>
    // `;
    deleteButton.innerHTML = `<img class="minus-image" style="height:30px; width:30px" src="../static/general/icons8-remove-96.png" alt="??">`;
    deleteButton.type = "button";
    deleteButton.onclick = removeField;

    deleteButtonDiv.appendChild(deleteButton);


    // Generate unique ID for the new city input
    let newInputId = 1;
    const existingInputs = document.querySelectorAll('.city-input');
    if (existingInputs.length > 0) {
        newInputId = parseInt(existingInputs[existingInputs.length - 1].id.split('-')[2]) + 1;
    }
    input.id = `street-city-${newInputId}`;
    input.name = `street-city-${newInputId}`;

    div.appendChild(label);
    div.appendChild(input);

    inputbuttonDiv = document.createElement("div");
    inputbuttonDiv.appendChild(div);
    inputbuttonDiv.appendChild(deleteButtonDiv);

    container.appendChild(inputbuttonDiv);
    // Initialize autocomplete for dynamically added city input
    // NECESAR IN PROD MODE 
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!initAutocomplete(input);
    initAutocomplete(input);
}


function addTimeField(container) {


    //don't add it if already exists
    if (container.childElementCount > 2)
        return 0

    const startTimeDiv = document.createElement("div");
    startTimeDiv.classList.add("elem-group");
    startTimeDiv.classList.add("inlined");

    const endTimeDiv = document.createElement("div");
    endTimeDiv.classList.add("elem-group");
    endTimeDiv.classList.add("inlined");

    const startLabel = document.createElement("label");
    startLabel.textContent = "Start Time";
    const endLabel = document.createElement("label");
    endLabel.textContent = "End Time";

    const startInput = document.createElement("input");
    startInput.classList.add("start-time");
    startInput.classList.add("time-selection");
    startInput.type = "date";

    const endInput = document.createElement("input");
    endInput.classList.add("end-time");
    endInput.classList.add("time-selection");
    endInput.type = "date";

    startTimeDiv.appendChild(startLabel);
    startTimeDiv.appendChild(startInput);

    endTimeDiv.appendChild(endLabel);
    endTimeDiv.appendChild(endInput);

    container.appendChild(startTimeDiv);
    container.appendChild(endTimeDiv);
}

function addRegistrationDateField() {

    const registraitonDateFieldContainer = document.getElementById("registration_date_container");

    if (registraitonDateFieldContainer.childElementCount === 0) {
        registraitonDateFieldContainer.classList.add("elem-group");
        registraitonDateFieldContainer.classList.add("registration-date");

        const label = document.createElement("label");
        label.textContent = "Last Registration Date:";

        const input = document.createElement("input");
        input.id = "registration-date-input";
        input.classList.add("registration-date-input");
        input.classList.add("time-selection");
        input.type = "date";

        registraitonDateFieldContainer.appendChild(label);
        registraitonDateFieldContainer.appendChild(input);

        // container.appendChild(registraitonDateFieldContainer);
    }
    else console.log("Registration date is already filled in!");
}


// Function to remove the last city input field
// function removeField() {
//     const container = document.getElementById('city-inputs-container');
//     if (container.children.length > 1) {
//         container.removeChild(container.lastChild);
//     }
// }
// Function to remove the grandparent div of the delete button

function removeField() {
    const deleteButton = this; // 'this' refers to the button clicked
    const grandparentDiv = deleteButton.parentNode.parentNode;
    const container = grandparentDiv.parentNode;

    if (container.children.length > 1) {
        container.removeChild(grandparentDiv);
    }
}

function removeTimeFields(container) {
    console.log("Removing ...");

    const timeDivs = container.getElementsByClassName("inlined");
    console.log(timeDivs);
    while (timeDivs.length > 0) {
        timeDivs[0].parentNode.removeChild(timeDivs[0]);
    }

}

function removeRegistrationDateField() {
    console.log("Removing reg date children...");

    var timeDiv = document.getElementById("registration_date_container");
    console.log(timeDiv);
    if (timeDiv !== null) {
        while (timeDiv.firstChild) {
            timeDiv.removeChild(timeDiv.firstChild);
        }
    } else {
        console.log("Element not found.");
    }
}


function updateTextBoxes() {
    console.log("update text boxes");

    const selectMenu = document.getElementById('saved-routes');
    const selectedRoute = selectMenu.value; // Get the selected route value (JSON string)
    const container = document.getElementById('city-inputs-container');
    var currentTextBoxes = container.children.length;
    console.log('cate boxuri', currentTextBoxes)

    if (selectedRoute !== "") {
        // Parse the JSON string to get the array of destinations
        const destinationsArray = JSON.parse(selectedRoute);
        console.log('lungime', destinationsArray);
        // Determine the number of textboxes required based on the number of destinations
        console.log("requiredTextBoxes", destinationsArray.length);

        // Add or remove textboxes to match the required number
        while (currentTextBoxes < destinationsArray.length) {
            addField();
            currentTextBoxes++;
            console.log(currentTextBoxes);
        }
        while (currentTextBoxes > destinationsArray.length) {
            removeField();
            currentTextBoxes--;
        }
        populateTextBoxes(destinationsArray);
    }
}


// Function to populate existing textboxes with destinations
function populateTextBoxes(destinationsArray) {
    console.log("Populating textboxes...");
    console.log("Destinations array:", destinationsArray);

    const container = document.getElementById('city-inputs-container');
    const textBoxes = container.querySelectorAll('.city-input');
    console.log("Number of textboxes:", textBoxes.length);
    const countriesWTpLEZ = ['Italy', 'Bulgaria'];

    textBoxes.forEach((textBox, index) => {
        console.log("Populating textbox", index + 1);
        if (destinationsArray[index]) {
            console.log('aaa', destinationsArray[index]);
            for (var countryWpTLEZ of countriesWTpLEZ) {
                if (destinationsArray[index].includes(countryWpTLEZ)) { //special condition for LEZ countries
                    addTimeField(textBox.parentElement);
                }
            }

            if (destinationsArray[index].includes('Poland')) { //special condition for poland last reg date
                addRegistrationDateField();
            }
            textBox.value = destinationsArray[index];
        }
    });
}


// Function to initialize autocomplete for a city input field
function initAutocomplete(input) {
    var options = {
        minLength: 4
    }
    const autocomplete = new google.maps.places.Autocomplete(input, options);
    autocomplete.addListener("place_changed", () => {
        const place = autocomplete.getPlace();
        if (!place.geometry || !place.geometry.location) {
            window.alert("No details available for input: '" + place.name + "'");
            return;
        }
        var country = getComponent(place, 'country');
        var city = getComponent(place, 'locality');
        console.log("city " + city);
        console.log("country " + country)

        if (country === 'Bulgaria' || country === 'Italy') {
            // Pass the container to addTimeField
            addTimeField(input.parentElement);
        }


        else {
            // Pass the container to removeTimeFields
            removeTimeFields(input.parentElement);
        }

        if (country === 'Poland') {
            addRegistrationDateField();
        }

        // else {
        //     removeRegistrationDateField();
        // }

        // You can handle population of other inputs here if needed
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


// Call initAutocomplete function for the first city input box when the page loads
window.onload = function () {
    const firstInput = document.getElementById('street-city-1');
    if (firstInput) {
        initAutocomplete(firstInput);
    }
};


function calculateDirections(destinations) {
    // Initialize the DirectionsService
    var directionsService = new google.maps.DirectionsService();
    var directionsRenderer = new google.maps.DirectionsRenderer();
    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 6,
        center: { lat: 51.509865, lng: -0.118092 },
        disableDefaultUI: true,
    });

    // Geocode each destination address
    var geocoder = new google.maps.Geocoder();
    var waypoints = [];

    destinations.forEach((destination, index) => {
        geocoder.geocode({ address: destination }, function (results, status) {
            if (status === 'OK') {
                waypoints[index] = {
                    location: results[0].geometry.location,
                    stopover: true
                };

                // If all destinations are geocoded, make the route request
                if (waypoints.length === destinations.length && waypoints.every(waypoint => waypoint)) {
                    var request = {
                        origin: waypoints[0].location, // Assuming the first destination as the origin
                        destination: waypoints[waypoints.length - 1].location, // Assuming the last destination as the destination
                        waypoints: waypoints.slice(1, -1), // Exclude the origin and destination from waypoints array
                        travelMode: 'DRIVING'
                    };

                    // Make the DirectionsService route request
                    directionsService.route(request, function (response, status) {
                        if (status === 'OK') {
                            // Render the directions on the map
                            directionsRenderer.setMap(map);
                            directionsRenderer.setDirections(response);
                        } else {
                            console.error('Error fetching directions:', status);
                        }
                    });
                }
            } else {
                console.error('Geocode was not successful for the following reason:', status);
            }
        });
    });
}


async function displayDescription(response) {
    // Clear previous descriptions and images
    const descriptionContainer = document.getElementById('description-container');
    descriptionContainer.innerHTML = '';
    var br = document.createElement('br');

    // Create an object to store city images
    const cityImages = {};

    // Iterate over each city in the response
    for (const city in response) {
        if (response.hasOwnProperty(city)) {
            const cityData = response[city];
            const notificationType = cityData.notification_type;
            const notificationMsg = cityData.notification_msg;
            const cityOfficialPage = cityData.city_official_page;
            const cityInfoForTemp = cityData.city_info_for_temp;

            console.log("testul 2:" + cityInfoForTemp);

            // Generate zone description text for the current city
            const descriptionText = await generateZoneDescription(cityData, city, cityInfoForTemp, notificationType, notificationMsg);

            // Create elements for description
            const div = document.createElement('div');
            div.classList.add('description');

            // Set class based on notification type
            const messageClass = getClassType(notificationType);
            div.classList.add(messageClass);

            // Create and set content for the description
            const cityName = document.createElement('h3');
            cityName.classList.add("city-name");
            cityName.textContent = city.toUpperCase();
            const msgParagraph = document.createElement('p');
            msgParagraph.classList.add("city-paragraph")
            msgParagraph.innerHTML = descriptionText; // Set HTML content

            // Append elements to the description container
            div.appendChild(cityName);
            div.appendChild(msgParagraph);


            if (notificationType != 'success-no-lez') {
                // Create container for anchor tags
                const aContainer = document.createElement('div');
                aContainer.classList.add('anchor-container');
                div.appendChild(aContainer);

                // Redirect to eligibility check
                const aTag1 = document.createElement('a');
                aTag1.classList.add("redirect-link");
                aTag1.setAttribute('href', '/eligibility-check');
                aTag1.innerText = "Click here to check your car's eligibility for registrations.";
                aContainer.appendChild(br.cloneNode()); // Append cloned br before aTag1
                aContainer.appendChild(aTag1);

                // Redirect to official page
                const aTag2 = document.createElement('a');
                aTag2.classList.add("redirect-link");
                aTag2.setAttribute('href', cityOfficialPage || '#');
                aTag2.innerText = "Further information on the official page.";
                aContainer.appendChild(br.cloneNode()); // Append cloned br before aTag2
                aContainer.appendChild(aTag2);
            }
            // Append description container to the main container
            descriptionContainer.appendChild(div);

        }
    }
}


async function generateZoneDescription(cityData, city, cityInfoForTemp, notificationType, notificationMsg) {
    let descriptionText = '';
    const cityAQI = await getAQIData(city);
    console.log("AQI in " + city + " is " + cityAQI);

    // Add zone city and country information
    if (notificationMsg.includes("There is no LEZ") || (notificationMsg.includes("There are no LEZs in"))) {
        descriptionText += `City: ${city}, ${cityData.country || 'Not found'}. <br>`;
        descriptionText += `Air Qulity Index: ${cityAQI}. <br>`;
        descriptionText += `${notificationMsg || 'Not found'} <br>`;
        return descriptionText;

    }
    else {
        descriptionText += `Low Emission Zone: ${city}, ${cityData.country || 'Not found'}. <br>`;
        descriptionText += `Air Qulity Index: ${cityAQI}. <br>`;
        descriptionText += `${notificationMsg || 'Not found'} <br>`;
        descriptionText += `${cityData.city_fines || 'Not found'}  <br>`;

        if (cityInfoForTemp != "None") {
            descriptionText += `${cityInfoForTemp || 'Not found'}  <br>`;
            console.log("tempo: " + cityInfoForTemp);
        }

    }

    return descriptionText;
}



async function getAQIData(city) {
    const apiUrl = `https://api.waqi.info/feed/${encodeURIComponent(city)}/?token=82645b03feba4f3384606a8471f00510abc10c37`;
    try {
        const response = await fetch(apiUrl);
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


async function handleFormSubmission() {
    // Get selected car
    const selectedCar = document.getElementById('selected-car').value;
    const carRegistrationDateElement = document.getElementById('registration-date-input');
    const carRegistrationDate = carRegistrationDateElement ? carRegistrationDateElement.value : null;

    if (carRegistrationDateElement && carRegistrationDateElement.value === '') {
        alert("Please select the vehicle registration date.")
        return;
    }
    // Get destination data
    const destinations = document.querySelectorAll('.city-input');
    const timeInfo = document.querySelectorAll(".time-selection");
    const destinationAddresses = [];
    const countryCityData = []; // New array for country and city data

    let startTimeValues = []; // Array to store start time values
    let endTimeValues = []; // Array to store end time values

    console.log("dest " + destinations);

    // Extract destination addresses and geocode them to get city and country
    for (const destinationInput of destinations) {
        const address = destinationInput.value.trim(); // Trim any leading/trailing spaces
        if (address !== '') {
            destinationAddresses.push(address);
            // Geocode the address to get city and country
            const geocoder = new google.maps.Geocoder();
            const results = await geocodeAddress(geocoder, address);
            if (results && results[0]) {
                let city = "";
                let country = "";
                results[0].address_components.forEach(component => {
                    if (component.types.includes('locality')) {
                        city = component.long_name;
                    } else if (component.types.includes('country')) {
                        country = component.long_name;
                    }
                });
                // Create an object for the city with country and city name
                const cityData = { country: country, city: city };
                // Find the parent container for the city input
                const parentContainer = destinationInput.closest('.elem-group');
                if (parentContainer) {
                    console.log("if1");
                    // Check if time inputs exist within the parent container
                    const startTimeInput = parentContainer.getElementsByClassName("start-time")[0];
                    const endTimeInput = parentContainer.getElementsByClassName("end-time")[0];

                    if (startTimeInput && endTimeInput) {
                        // Add time inputs to city data
                        console.log("if2");
                        if (startTimeInput.value === '' || endTimeInput.value === '') {
                            alert("Please fill complete the dates of travelling in " + city)
                            return;
                        }
                        cityData.startTime = startTimeInput.value;
                        cityData.endTime = endTimeInput.value;
                    }

                }
                // Push the city data object to the countryCityData array
                countryCityData.push(cityData);
            } else {
                console.error('Geocode was not successful for address:', address);
            }
        }
    }



    // Convert destination addresses to a comma-separated string
    const destinationData = destinationAddresses.join(',');

    // Convert country and city data to JSON string
    const countryCityDataJSON = JSON.stringify(countryCityData);
    console.log("js" + countryCityDataJSON);

    // AJAX request to send data to backend
    const formData = new FormData();
    formData.append('selected-car', selectedCar);
    formData.append('selected-car-registration-date', carRegistrationDate);
    formData.append('destinations', destinationData);
    formData.append('cityCountryData', countryCityDataJSON);
    console.log("form " + formData);

    try {
        const response = await fetch('/maps', {
            method: 'POST',
            body: formData
        });
        if (!response.ok) {
            throw new Error('Failed to send data to backend');
        }
        // Request successful, calculate directions using full addresses
        calculateDirections(destinationAddresses);

        // Parse the JSON response from backend
        const responseData = await response.json();

        // Display the descriptions with full control
        displayDescription(responseData);
        // toggleDescriptionVisibility();
    } catch (error) {
        console.error('Error sending data to backend:', error);
    }
}

async function saveTrip() {
    const selectedCar = document.getElementById('selected-car').value;
    const destinations = document.querySelectorAll('.city-input');
    const destinationAddresses = [];

    for (const destinationInput of destinations) {
        const address = destinationInput.value.trim(); // Trim any leading/trailing spaces
        if (address !== '') {
            destinationAddresses.push(address);
        }
    }

    console.log(destinationAddresses);

    const destinationData = JSON.stringify(destinationAddresses);

    console.log(destinationData);

    const formData = new FormData();
    formData.append('selected-car', selectedCar);
    formData.append('destinations', destinationData);

    try {
        const response = await fetch('/save-route', {
            method: 'POST',
            body: formData
        });
        if (!response.ok) {
            throw new Error('Failed to send data to backend');
        }

        // Show a success notification
        alert('Route saved successfully!');

        // Refresh the page
        window.location.reload();

    } catch (error) {
        console.error('Error sending data to backend:', error);

        // Show an error notification
        alert('Error saving trip. Please try again.');
    }
}


function geocodeAddress(geocoder, address) {
    return new Promise((resolve, reject) => {
        geocoder.geocode({ address: address }, (results, status) => {
            if (status === 'OK') {
                resolve(results);
            } else {
                reject(status);
            }
        });
    });
}



// Initialize the map
function initMap() {
    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5.5,
        center: { lat: 47.509865, lng: 14 },
        gestureHandling: "cooperative",
        disableDefaultUI: true,

        // label: {
        //     fontFamily: 'Georgia, serif',
        // },
        // resolution: 'high'



    });

    // Adjust map styles to make certain elements more transparent
    //     map.setOptions({
    //         styles: [
    //             {
    //                 "stylers": [
    //                     { "saturation": -80 }, // Decrease saturation adjustment
    //                     { "lightness": 60 }, // Increase lightness adjustment
    //                     { "visibility": "simplified" } // Simplify the map
    //                 ]
    //             },
    //             {
    //                 "elementType": "labels",
    //                 "stylers": [
    //                     { "visibility": "on" },
    //                     { "color": "#E1D2BC" } // Show labels on the map
    //                 ]
    //             },
    //             {
    //                 "featureType": "road",
    //                 "stylers": [
    //                     { "visibility": "on" }, // Show roads
    //                     { "color": "#B29162" } // Set road color to white
    //                 ]
    //             },
    //             {
    //                 "featureType": "water",
    //                 "stylers": [
    //                     { "color": "#2F5F89" } // Set water color to a lively blue
    //                 ]
    //             },
    //             {
    //                 "featureType": "landscape",
    //                 "stylers": [
    //                     { "color": "#1F7635" }, // Set landscape color to a light gray
    //                     { "visibility": "on" } // Show landscape features
    //                 ]
    //             },
    //             {
    //                 "featureType": "administrative.land_parcel",
    //                 "stylers": [
    //                     { "visibility": "on" } // Hide land parcel boundaries
    //                 ]
    //             },
    //             {
    //                 "featureType": "poi",
    //                 "stylers": [
    //                     { "visibility": "off" } // Hide points of interest
    //                 ]
    //             }
    //         ]
    //     });

    //     // Create a shadow div and append it to the map container
    //     var shadowDiv = document.createElement('div');
    //     shadowDiv.id = 'map-shadow';
    //     document.getElementById('map-container').appendChild(shadowDiv);
}