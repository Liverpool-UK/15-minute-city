---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
  <div id="mainmap">
  </div>
  <script>
    var mainMap;
    window.onload = function() {
      mainMap = L.map('mainmap').setView([53.4105095,-2.9704659], 12)
      //mainMap = L.map('mainmap').setView([51.505, -0.09], 13);
      var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';
      var ocmlink = '<a href="http://thunderforest.com/">Thunderforest</a>';
      L.tileLayer(
        'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=545d2bceafc34e60af2dd48c5ea3d00c', {
        attribution: '&copy; '+mapLink+' Contributors & '+ocmlink,
        maxZoom: 18,
        }).addTo(mainMap);
      // Load the isochrones
      var isochrone = JSON.parse(iso);
      console.log(isochrone);
      L.geoJSON(isochrone).addTo(mainMap);
    }
  </script>
