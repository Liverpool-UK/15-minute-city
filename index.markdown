---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
<div id="sidebar">
  <h1>Could Liverpool be a 15 Minute City?</h1>
  <p>A website to explore a Liverpool where your everyday needs are within a 15 minute walk or cycle.</p>
  <p><strong>This site is a work-in-progress</strong>.  See <a href="https://github.com/Liverpool-UK/somebody-should/issues/35">this discussion</a> or talk to <a href="https://twitter.com/amcewen">Adrian McEwen</a> to find out more.</p>
  <h3>Key</h3>
  <ul>
    <li style="color: #5ecc3f">Area within 15 minutes' walk for those with reduced mobility</li>
    <li style="color: #cc5e3f">Area within 15 minutes' walk</li>
    <li style="color: #3fadcc">Area within 15 minutes' cycling</li>
  </ul>
  <h3>Areas</h3>
  <table id="area-grid">
    <tr>
      <th>Area</th><th>Reduced Mobility</th><th>Walking</th><th>Cycling</th>
    </tr>
  {% for area in site.data.areas %}
    <tr>
      <td>{{ area.name }}</td>
      <td class="toggle reduced">
      {% if area.reducedurl %}
        <input onchange="toggleIsochrone(event.target, {{ forloop.index0 }}, 'reduced')" type="checkbox" checked="true" name="{{ area.name }}-reduced" id="check-{{ area.name }}-reduced"/>
      {% endif %}
      </td>
      <td class="toggle walk">
      {% if area.walkurl %}
        <input onchange="toggleIsochrone(event.target, {{ forloop.index0 }}, 'walk')" type="checkbox" checked="true" name="{{ area.name }}-walk" id="check-{{ area.name }}-walk"/>
      {% endif %}
      </td>
      <td class="toggle bicycle">
      {% if area.bicycleurl %}
        <input onchange="toggleIsochrone(event.target, {{ forloop.index0 }}, 'bicycle')" type="checkbox" checked="true" name="{{ area.name }}-bicycle" id="check-{{ area.name }}-bicycle"/>
      {% endif %}
      </td>
    </tr>
  {% endfor %}
  </table>
</div>
<div id="mainmap">
</div>
<script>
  var hiddenStyle = {
    "color": "#00000000",
    "weight": 0,
    "opacity": 0
  };
  var reducedStyle = {
    "color": "#5ecc3f",
    "weight": 1.5,
    "opacity": 0.85
  };
  var walkingStyle = {
    //"color": "#ff7800",
    "color": "#cc5e3f",
    "weight": 1.5,
    "opacity": 0.85
  };
  var bikingStyle = {
    "color": "#3fadcc",
    "weight": 1.5,
    "opacity": 0.65
  };
  var travelTypes = ["walk", "bicycle", "reduced"];
  var travelTypeStyles = {
    "bicycle": bikingStyle,
    "walk": walkingStyle,
    "reduced": reducedStyle
  };
  var mainMap;
  var areas = {% data_to_json areas %};

  function toggleIsochrone(ev, idx, tt) {
    if (ev.checked) {
      // Turn it on
      areas[idx][tt+'layer'].setStyle(travelTypeStyles[tt]);
    } else {
      // Hide the layer
      areas[idx][tt+'layer'].setStyle(hiddenStyle);
    }
    return false;
  }
  window.onload = function() {
    mainMap = L.map('mainmap').setView([53.4105095,-2.9704659], 12)
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';
    var ocmlink = '<a href="http://thunderforest.com/">Thunderforest</a>';
    L.tileLayer(
      'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=545d2bceafc34e60af2dd48c5ea3d00c', {
      attribution: '&copy; '+mapLink+' Contributors & '+ocmlink,
      maxZoom: 18,
      }).addTo(mainMap);
    // Load the isochrones
    travelTypes.forEach(function(tt) {
      for (var i =0; i < areas.length; i++) {
        if (areas[i][tt+"url"]) {
          const xhr = new XMLHttpRequest();
          xhr.open('GET', areas[i][tt+"url"]);
          xhr.responseType = 'json';
          xhr.area_idx = i;
          xhr.tt = tt;
          xhr.onload = function(e) {
            if (this.status == 200) {
              areas[this.area_idx][this.tt+"isochrone"] = this.response;
              // Add it to the map
              areas[this.area_idx][this.tt+"layer"] = L.geoJSON(areas[this.area_idx][this.tt+"isochrone"], { style: travelTypeStyles[this.tt] }).addTo(mainMap);
            }
          };
          xhr.send();
        }
      }
    });
  }
</script>
