---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
<div id="sidebar">
  <h1>Could Liverpool be a 15 Minute City?</h1>
  <p>A website to explore a Liverpool where your <em>everyday</em> needs are within a 15 minute walk or cycle.</p>
  <p><strong>This site is a work-in-progress</strong>.  See <a href="https://github.com/Liverpool-UK/somebody-should/issues/35">this discussion</a> or talk to <a href="https://twitter.com/amcewen">Adrian McEwen</a> to find out more.</p>
  <h3>Key</h3>
  <ul>
    <li style="color: #5ecc3f">Area within 15 minutes' walk for those with reduced mobility</li>
    <li style="color: #cc5e3f">Area within 15 minutes' walk</li>
    <li style="color: #3fadcc">Area within 15 minutes' cycling</li>
  </ul>
  <h3 id="areas">Areas</h3>
  <p>Turn isochrones on/off by clicking on the area name, type of isochrones, or individual checkboxes.</p>
  <table id="area-grid">
    <tr>
      <th>Area</th>
      <th class="toggle-target" onclick="toggleClass('reduced')">Reduced Mobility</th>
      <th class="toggle-target" onclick="toggleClass('walk')">Walking</th>
      <th class="toggle-target" onclick="toggleClass('bicycle')">Cycling</th>
    </tr>
  {% for area in site.data.areas %}
    <tr>
      <td class="toggle-target" onclick="toggleClass('{{ area.name }}')">{{ area.name }}</td>
      {% if area.reducedurl %}
      <td class="toggle reduced">
        <input onchange="updateIsochroneVisibility()" type="checkbox" checked name="{{ area.name }}-reduced" id="check-{{ area.name }}-reduced" class="check-reduced check-{{ area.name }}" />
      {% else %}
      <td colspan="3" class="data-missing">data missing. <a href="https://github.com/Liverpool-UK/15-minute-city/issues/4">Want to help?</a>
      {% endif %}
      </td>
      <td class="toggle walk">
      {% if area.walkurl %}
        <input onchange="updateIsochroneVisibility()" type="checkbox" checked name="{{ area.name }}-walk" id="check-{{ area.name }}-walk" class="check-walk check-{{ area.name }}" />
      {% endif %}
      </td>
      <td class="toggle bicycle">
      {% if area.bicycleurl %}
        <input onchange="updateIsochroneVisibility()" type="checkbox" name="{{ area.name }}-bicycle" id="check-{{ area.name }}-bicycle" class="check-bicycle check-{{ area.name }}" />
      {% endif %}
      </td>
    </tr>
  {% endfor %}
  </table>
  <h3 id="cycleways">New Cycle Routes?</h3>
  <p>In response to the COVID-19 crisis, <a href="https://twitter.com/robinlovelace">Robin Lovelace</a> has been <a href="">working out where we could easily add new cycle routes</a>.</p>
  <p>These options show the results of his analysis on the map:</p>
  <table id="new-cycleways-grid">
  {% for cycleway in site.data.cycleways %}
    <tr>
      <td>{{ cycleway.description }}</td>
      <td class="toggle">
        <input onchange="setIsochroneVisibility(cycleways[{{ forloop.index0 }}].layer, 'cycleways', 'cycleways-{{ cycleway.name }}')" type="checkbox" name="cycleways-{{ cycleway.name }}" id="check-cycleways-cycleways-{{ cycleway.name }}" class="check-cycleways" />
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
  var cyclewaysExistingStyle = {
    "color": "#906",
    "weight": 3.5,
    "opacity": 0.8
  };
  var cyclewaysNewStyle = {
    "color": "#909",
    "weight": 3.5,
    "opacity": 0.8
  };
  var cyclewaysCohesiveStyle = {
    "color": "#606",
    "weight": 3.5,
    "opacity": 0.8
  };
  var cyclewaysSpareStyle = {
    "color": "#606",
    "weight": 3.5,
    "opacity": 0.8
  };
  var cyclewaysWideStyle = {
    "color": "#606",
    "weight": 3.5,
    "opacity": 0.8
  };
  var travelTypes = ["walk", "bicycle", "reduced"];
  var travelTypeStyles = {
    "bicycle": bikingStyle,
    "walk": walkingStyle,
    "reduced": reducedStyle,
    "cycleways-existing": cyclewaysExistingStyle,
    "cycleways-new": cyclewaysNewStyle,
    "cycleways-cohesive": cyclewaysCohesiveStyle,
    "cycleways-spare": cyclewaysSpareStyle,
    "cycleways-wide": cyclewaysWideStyle
  };
  var mainMap;
  var areas = {% data_to_json areas %};
  var cycleways = {% data_to_json cycleways %};

  // Read the state of the checkboxes and set the isocrhone visibility accordingly
  function updateIsochroneVisibility() {
    areas.forEach(function(a) {
      setIsochroneVisibility(a.reducedlayer, a.name, 'reduced');
      setIsochroneVisibility(a.walklayer, a.name, 'walk');
      setIsochroneVisibility(a.bicyclelayer, a.name, 'bicycle');
    });
  }
  // Show/hide the given isochrone based on its checkbox state
  function setIsochroneVisibility(layer, area, tt) {
    if (layer) {
      var checkbox = document.getElementById('check-'+area+'-'+tt);
      if (checkbox.checked) {
        // Turn it on
        layer.setStyle(travelTypeStyles[tt]);
      } else {
        // Hide the layer
        layer.setStyle(hiddenStyle);
      }
    }
  }
  function toggleClass(tt) {
    var checkboxes = document.getElementsByClassName('check-'+tt);
    // Toggle based on whatever state the first one has
    var newState = !checkboxes[0].checked;
    for (var i =0; i < checkboxes.length; i++) {
      checkboxes[i].checked = newState;
    }
    updateIsochroneVisibility();
  }
  window.onload = function() {
    mainMap = L.map('mainmap').setView([53.4105095,-2.9704659], 13)
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';
    var ocmlink = '<a href="http://thunderforest.com/">Thunderforest</a>';
    L.tileLayer(
      'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=545d2bceafc34e60af2dd48c5ea3d00c', {
      attribution: '&copy; '+mapLink+' Contributors & '+ocmlink,
      maxZoom: 18,
      }).addTo(mainMap);
    // Load rapid cycleway prioritisation layers
    for (var i =0; i < cycleways.length; i++) {
      const cexhr = new XMLHttpRequest();
      cexhr.open('GET', cycleways[i].url);
      cexhr.responseType = 'json';
      cexhr.cycleway_idx = i;
      cexhr.onload = function(e) {
        if (this.status == 200) {
          cycleways[this.cycleway_idx].layer = L.geoJSON(this.response, { style: travelTypeStyles['cycleways-'+cycleways[this.cycleway_idx].name] }).addTo(mainMap);
          // Set its visibility accordingly
          setIsochroneVisibility(cycleways[this.cycleway_idx].layer, 'cycleways', 'cycleways-'+cycleways[this.cycleway_idx].name);
        }
      };
      cexhr.send();
    }
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
              // FIXME Ideally we'd wait for all of these to load then call this once...
              updateIsochroneVisibility();
            }
          };
          xhr.send();
        }
      }
    });
  }
</script>
