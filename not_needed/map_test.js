"use strict";

const CONFIGURATION = {
    "ctaTitle": "Checkout",
    "mapOptions": {
        "center": {
            "lat": 37.4221,
            "lng": -122.0841
        },
        "fullscreenControl": true,
        "mapTypeControl": false,
        "streetViewControl": true,
        "zoom": 11,
        "zoomControl": true,
        "maxZoom": 22,
        "mapId": ""
    },
    "mapsApiKey": "AIzaSyDSrGZOUl7LV020hIPMv0WXyKemXGj0Vgk",
    "capabilities": {
        "addressAutocompleteControl": true,
        "mapDisplayControl": true,
        "ctaControl": true
    }
};

const SHORT_NAME_ADDRESS_COMPONENT_TYPES =
    new Set(['street_number', 'administrative_area_level_1', 'postal_code']);

const ADDRESS_COMPONENT_TYPES_IN_FORM = [
    'location',
    'locality',
    'administrative_area_level_1',
    'postal_code',
    'country',
];

function getFormInputElementOrigin(componentType) {
    return document.getElementById(`${componentType}-origin`);
}

function getFormInputElementDestination(componentType) {
    return document.getElementById(`${componentType}-destination`);
}

function fillInAddress(place) {
    function getComponentName(componentType) {
        for (const component of place.address_components || []) {
            if (component.types[0] === componentType) {
                return SHORT_NAME_ADDRESS_COMPONENT_TYPES.has(componentType) ?
                    component.short_name :
                    component.long_name;
            }
        }
        return '';
    }

    function getComponentText(componentType) {
        return (componentType === 'address') ?
            `${getComponentName('street_number')} ${getComponentName('route')}` :
            getComponentName(componentType);
    }

    for (const componentType of ADDRESS_COMPONENT_TYPES_IN_FORM) {
        getFormInputElementOrigin(componentType).value = getComponentText(componentType);
    }

    for (const componentType of ADDRESS_COMPONENT_TYPES_IN_FORM) {
        getFormInputElementDestination(componentType).value = getComponentText(componentType);
    }



}

function renderAddress(place, map, marker) {
    if (place.geometry && place.geometry.location) {
        map.setCenter(place.geometry.location);
        marker.position = place.geometry.location;
    } else {
        marker.position = null;
    }
}

async function initMap() {
    const {
        Map
    } = google.maps;
    const {
        AdvancedMarkerElement
    } = google.maps.marker;
    const {
        Autocomplete
    } = google.maps.places;

    const mapOptions = CONFIGURATION.mapOptions;
    mapOptions.mapId = mapOptions.mapId || 'DEMO_MAP_ID';
    mapOptions.center = mapOptions.center || {
        lat: 37.4221,
        lng: -122.0841
    };

    const map = new Map(document.getElementById('gmp-map'), mapOptions);
    const marker = new AdvancedMarkerElement({
        map
    });
    const autocomplete = new Autocomplete(getFormInputElement('location'), {
        fields: ['address_components', 'geometry', 'name'],
        types: ['address'],
    });

    autocomplete.addListener('place_changed', () => {
        const place = autocomplete.getPlace();
        if (!place.geometry) {
            // User entered the name of a Place that was not suggested and
            // pressed the Enter key, or the Place Details request failed.
            window.alert(`No details available for input: '${place.name}'`);
            return;
        }
        renderAddress(place, map, marker);
        fillInAddress(place);
    });
}
