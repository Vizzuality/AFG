OpenLayers.DOTS_PER_INCH = 90.71428571428572;
OpenLayers.Util.onImageLoadErrorColor = 'transparent';
var map, popup, urlParams = {};

// Maps the url querystring to a Javascript object
(function () {
  var e,
      a = /\+/g,  // Regex for replacing addition symbol with a space
      r = /([^&=]+)=?([^&]*)/g,
      d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
      q = window.location.search.substring(1);

  while (e = r.exec(q))
   urlParams[d(e[1])] = d(e[2]);
})();

  $(document).ready(function() {
    $('div.map img.loading').css('display','inline');
    $('div.map img.loading').css('z-index','5000');
    
    $.getJSON('/api/maps/features', function(data){
      
      var mapOptions = { 
        resolutions: [50694.68146875, 25347.340734375, 12673.6703671875, 6336.83518359375, 3168.417591796875, 1584.2087958984375, 792.1043979492188, 396.0521989746094, 198.0260994873047, 99.01304974365235, 49.50652487182617, 24.753262435913086, 12.376631217956543, 6.188315608978272, 3.094157804489136, 1.547078902244568, 0.773539451122284, 0.386769725561142, 0.193384862780571, 0.0966924313902855, 0.04834621569514275, 0.024173107847571373, 0.012086553923785687, 0.006043276961892843, 0.0030216384809464217],
        projection: new OpenLayers.Projection('EPSG:3031'),
        maxExtent: new OpenLayers.Bounds(-6267731.972,-5502339.632,6710106.484,7475498.824),
        units: "meters",
        numZoomLevels:3,
        controls: [],
        restrictedExtent: new OpenLayers.Bounds(-6267731.972,-5502339.632,4885097.951125,5270280.1801067)
      };
      var markers = new OpenLayers.Layer.Markers( "Markers" );

      loadMarkersAndPictures(markers, data);

      map = new OpenLayers.Map('map', mapOptions );
      map.addControl(new OpenLayers.Control.Navigation({zoomWheelEnabled : false}));
      map.addControl(new OpenLayers.Control.MousePosition({element: $('location')}));
      var demolayer = new OpenLayers.Layer.WMS(
          "aadc:wider_antarctica","/maps/tiles",
          {
            'layers': 'aadc:wider_antarctica',
            'format': 'image/png'
          },
          {
            'tileSize': new OpenLayers.Size(256,256),
            'eventListeners': {
              'loadend': function(evt){
                map.addLayer(markers);
              }
            }
          }
      );
      map.addLayer(demolayer);
      map.zoomToExtent(new OpenLayers.Bounds(-6267731.972,-5502339.632,0,7));
      map.setCenter(new OpenLayers.LonLat(0,7),2);
      
      //Control double click handler
      var dblclick = new OpenLayers.Handler.Click(this, {
        dblclick: function() { 
          if (map.getZoom()<4) {
            map.zoomIn()
          } 
        },
        click: null 
      }, 
      {
        single: true, 
        'double': true, 
        stopSingle: false, 
        stopDouble: true
      });
      dblclick.setMap(map);
      dblclick.activate();
    });
  });
  
  // Places markers and pictures over the map
  function loadMarkersAndPictures(markers, data){
    var size       = new OpenLayers.Size(5,5);
    var offset     = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
    var occurrence = new OpenLayers.Icon('../images/map/occurrence.png',size,offset);
    var data_occurrence, openlayers_marker = OpenLayers.Marker, openlayers_lonlat = OpenLayers.LonLat;
    if (console && console.time) { console.time('chunk'); };
    if (!urlParams.m || urlParams.m == 1) {
      // LOOP 1 - Slowest, but asynchronous (browser doesn't get blocked)
      asyncLoop(data.occurrences, function(data_occurrence){
        markers.addMarker(
          new openlayers_marker(
            new openlayers_lonlat( data_occurrence.lon, data_occurrence.lat),
            occurrence.clone())
        );
      }, function(){
        $('div.map img.loading').fadeOut('fast');
        if (console && console.timeEnd) { console.timeEnd('chunk'); };
      }, this);
    }else if (urlParams.m == 2){
      // LOOP 2 - Fastest, but synchronous
      while(data.occurrences.length > 0){
        data_occurrence = data.occurrences.shift();
        markers.addMarker(
          new openlayers_marker(
            new openlayers_lonlat( data_occurrence.lon, data_occurrence.lat),
            occurrence.clone())
        );
      }
      $('div.map img.loading').fadeOut('fast');
      if (console && console.timeEnd) { console.timeEnd('chunk'); };
    };

    size   = new OpenLayers.Size(81,63);
    offset = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
    var data_landscape;
    asyncLoop(data.landscapes, function(data_landscape){
      markers.addMarker(
        new LandscapeMarker(
          new OpenLayers.LonLat(data_landscape.lon,data_landscape.lat),
          new OpenLayers.Icon(data_landscape.picture,size,offset),
          data_landscape
        )
      );
    }, function(){
      
    }, this);
  }
  
  function asyncLoop(array, process, end, context){
    setTimeout(function(){
      var item = array.shift();
      process.call(context, item);

      if (array.length > 0){
        setTimeout(arguments.callee, 0);
      }else{
        if (end) {end.call(context)};
      }
    }, 0);
  }

  function zoomIn() {
    if (map.getZoom() < 4) {
      map.zoomIn();
    }
  }
  
  function zoomOut() {
    if (map.getZoom() > 2 && map.getZoom() < 5) {
      map.zoomOut();
    }
  }
  
  function toggleFullScreen() {
    if ($('div.map').css('position')!='absolute') {
      $('div.map').attr('style','position:absolute; top:0; left:0; width:100%; height:100%; padding:0; margin:0; background:white; z-index:100000');
      $('body').css('overflow','hidden');
      if (map.getZoom()==2) {
        map.zoomIn();
      }
      $('a,full_screen').addClass('back');
      $.scrollTo(0,0);
    } else {
      $('div.map').attr('style','position:relative; float:left; margin:20px 0 0 0; width:880px; height:373px; padding:8px 15px 13px; background:url(../images/common/map_bkg_shadow.png) no-repeat 5px bottom;');
      $('body').css('overflow','auto');
      if (map.getZoom()>2) {
        map.zoomTo(2);
      }
      $('a,full_screen').removeClass('back');
    }
  }
    
  
