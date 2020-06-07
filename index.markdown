---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
  <div id="mainmap">
  </div>
  <script>
    var walkingStyle = {
      "color": "#ff7800",
      "weight": 1.5,
      "opacity": 0.75
    };
    var mainMap;
    var areas = {% data_to_json areas %};
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
      for (var i =0; i < areas.length; i++) {
        console.log(areas[i].name + " "+areas[i].url);
        if (areas[i].url) {
          const xhr = new XMLHttpRequest();
          xhr.open('GET', areas[i].url);
          xhr.responseType = 'json';
          xhr.area_idx = i;
          xhr.onload = function(e) {
            if (this.status == 200) {
              areas[this.area_idx].isochrone = this.response;
              // Add it to the map
              L.geoJSON(areas[this.area_idx].isochrone, { style: walkingStyle }).addTo(mainMap);
            }
          };
          xhr.send();
        }
      }
    }
  </script>
