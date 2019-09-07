"use strict";

$(document).ready(function() {
    initMap();
});

function initMap() {

    const mapId = 'location-map';
    const mapElement = $('#' + mapId);
    const location = {
        lat: mapElement.data('lat'),
        lon: mapElement.data('lon')
    };
    const popupText = mapElement.data('popup');

    const leafletMap = L.map(mapId)
        .setView([location.lat, location.lon], 16);

    leafletMap.scrollWheelZoom.disable();

    L.tileLayer(
        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        {
            attribution: 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
        }
    ).addTo(leafletMap);

    const marker = L.marker([location.lat, location.lon]);
    if (typeof popupText === 'string' && popupText.length > 0) {
        marker.bindPopup(popupText);
    }

    marker.addTo(leafletMap);
}
