$(function() {
  $('#district_id').select2({width: "120px"});

  var map = L.map('map', {crs: L.CRS.EPSG3857	}).setView([49.34629, -122.17871], 8);

  var skill_assessments = '';
  var schools = [];

  function reload_data() {
    for (school in schools) {
      map.removeLayer(schools[school].marker);

    }
    schools = [];

    var map_data = { "school": [], "district": []},
      school_url = "/skill_assessments?" + $('#filter').serialize(),
      district_url = "/district_skill_assessments?" + $('#filter').serialize();

    $.getJSON(school_url, {}, function(data) {
      map_data.school = data;

      $.each(data, function(i, school) {
        if (schools[school.school_name] == undefined) {
          schools[school.school_name] = {};
          schools[school.school_name].name = school.school_name;
          schools[school.school_name].coords = [school.school_latitude, school.school_longitude];
          schools[school.school_name].result_summary = "<b>" + school.school_name + "</b><br/>";
          if (school.scaled_score != null) {
            schools[school.school_name].opacity = school.scaled_score;
            schools[school.school_name].icon = "bar-chart-o"
          } else {
            schools[school.school_name].opacity = 0.8;
            schools[school.school_name].icon = "warning"
            schools[school.school_name].result_summary += "(some results may be incomplete)<br/>";
          }
        }
        if (school.scaled_score != null) {
          schools[school.school_name].opacity = ((schools[school.school_name].opacity + school.scaled_score) / 2);
        }
        schools[school.school_name].result_summary += "<br/>" + school.school_year + " Grade " + school.grade + " " + school.fsa_skill_code + "<br> " + school.percent_below + "% Below | " + school.percent_meeting + "% Meeting | " + school.percent_exceeding + "% Exceeding<br>";

      });
      for (school in schools) {
          // random marker -- markerTemplates[getRandomInt(0,markerTemplates.length-1)]
        schools[school].marker = L.marker(schools[school].coords, {opacity: ((schools[school].opacity - 0.4) * 2.3), icon: L.AwesomeMarkers.icon({ icon: schools[school].icon, prefix: 'fa', markerColor: 'red' })})
        .bindPopup(schools[school].result_summary).on('mouseover', function (e) {
            var thePopup = this;
            $.doTimeout( 'someid', 350, function(){
                thePopup.openPopup();
            });
          }).on('mouseout', function (e) {
              $.doTimeout( 'someid' );
              this.closePopup();
          });

        map.addLayer(schools[school].marker);
      }

    });

    $.getJSON(district_url, {}, function(data) {
      map_data.district = data;
    });
    return map_data;
  }
  $('form').find('select').on('change', function() {
    reload_data();
  });

  // comment this out -- requires form selection to begin loading data
  //reload_data();

  /*
  //see also http://leaflet-extras.github.io/leaflet-providers/preview/
  L.tileLayer('http://{s}.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg', {
  attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
  subdomains: 'abcd',
  minZoom: 3,
  maxZoom: 16
  }).addTo(map);
  */


  L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
    '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'examples.map-20v6611k'
    }).addTo(map);

    function getRandomInt(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    }

  var markerTemplates = [];
  $.each(['red', 'darkred', 'orange', 'green', 'darkgreen', 'cadetblue', 'blue', 'purple', 'darkpuple'], function(i, colour) {
    markerTemplates.push(L.AwesomeMarkers.icon({
      icon: 'coffee',
      markerColor: colour
    }));
  });

  function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
  }

  //var myLayer = L.geoJson({style: myStyle}).addTo(map);
  $.getJSON($('link[rel="points"]').attr("href"), function(data) {

    var geojson = L.geoJson(data, {
      style: function(feature) {
        return {color: "#333", opacity: 0.2 };
      },
        //style: myStyle,
        onEachFeature: function (feature, layer) {
          layer.active = false;

          var labelText = feature.properties.SDNAME;
          if (labelText === undefined) {
            labelText = feature.properties.NAME;
          }

          layer.on('click', function() {

            /*  auto-zooming makes less sense with boundaries showing & multi-click
            var bounds = layer.getBounds();
            map.fitBounds(bounds);
            map.setZoom(11);
            */

            if (!layer.active) {
              color = "#" + parseInt(getRandomArbitrary(100000,999999), 10);
              layer.setStyle({opacity: 0.8, color: color});
              layer.active = true;
            } else {
              layer.active = false;
              layer.setStyle({opacity: 0.2, color: "#333"});
            }

            $("#district_id option").filter(function() {
                //may want to use $.trim in here
                return $(this).val() == feature.properties.SDNUM;
            }).prop('selected', function( i, val ) { return !val; }).change();


          });

          if (labelText !== undefined) {
            var label = new L.Label();
            label.setContent(labelText);
            label.setLatLng(layer.getBounds().getCenter());
            label.updateZIndex(0);
            map.showLabel(label);

          }


        }
    });
    geojson.addTo(map,true);
  });

});
