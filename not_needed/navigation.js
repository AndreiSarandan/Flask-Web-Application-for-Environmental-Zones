function initMap() { alert("ok"); } {
    const input = document.getElementById("street-origin");
    const options = {
        fields: ["formatted_address", "geometry", "name"],
        strictBounds: false,
    };

    const autocomplete = new google.maps.places.Autocomplete(input, options);

    autocomplete.addListener("place_changed", () => {
        const place = autocomplete.getPlace();

        if (!place.geometry || !place.geometry.location) {
            window.alert("No details available for input: '" + place.name + "'");
            return;
        }

        console.log("Selected Place:", place.name);
        console.log("Formatted Address:", place.formatted_address);
        console.log("Location:", place.geometry.location.lat(), place.geometry.location.lng());
    });
}

window.initMap = initMap;