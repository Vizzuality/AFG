OpenLayers.DOTS_PER_INCH = 90.71428571428572;
OpenLayers.Util.onImageLoadErrorColor = 'transparent';
var map, popup;


	$(document).ready(function() {
			var mapOptions = { 
				resolutions: [50694.68146875, 25347.340734375, 12673.6703671875, 6336.83518359375, 3168.417591796875, 1584.2087958984375, 792.1043979492188, 396.0521989746094, 198.0260994873047, 99.01304974365235, 49.50652487182617, 24.753262435913086, 12.376631217956543, 6.188315608978272, 3.094157804489136, 1.547078902244568, 0.773539451122284, 0.386769725561142, 0.193384862780571, 0.0966924313902855, 0.04834621569514275, 0.024173107847571373, 0.012086553923785687, 0.006043276961892843, 0.0030216384809464217],
				projection: new OpenLayers.Projection('EPSG:3031'),
				maxExtent: new OpenLayers.Bounds(-6267731.972,-5502339.632,6710106.484,7475498.824),
				units: "meters",
				numZoomLevels:4,
				controls: []
			};


			map = new OpenLayers.Map('map', mapOptions );
			// map.addControl(new OpenLayers.Control.PanZoomBar({
			// 					position: new OpenLayers.Pixel(0, 0)
			// 			}));
			map.addControl(new OpenLayers.Control.Navigation({zoomWheelEnabled : false}));
			map.addControl(new OpenLayers.Control.MousePosition({element: $('location')}));
			var demolayer = new OpenLayers.Layer.WMS(
					"aadc:wider_antarctica","/maps/tiles",
					{layers: 'aadc:wider_antarctica', format: 'image/png' },
					{ tileSize: new OpenLayers.Size(256,256) }
			);
			map.addLayer(demolayer);
			map.zoomToExtent(new OpenLayers.Bounds(-6267731.972,-5502339.632,0,7));
			map.setCenter(new OpenLayers.LonLat(0,7),2);
			
			
			var markers = new OpenLayers.Layer.Markers( "Markers" );
			map.addLayer(markers);
			var size = new OpenLayers.Size(32,32);
			var offset = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
			var icon = new OpenLayers.Icon('http://maps.google.com/mapfiles/kml/pal2/icon0.png',size,offset);
			markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(0,7),icon));
			markers.events.register("click", markers, click);
			popup = new OpenLayers.Popup.Anchored("chicken", new OpenLayers.LonLat(0,7), new OpenLayers.Size(200,200), "example popup", {size: new OpenLayers.Size(200,200), offset: new OpenLayers.Pixel(100,-400)});
			
      
			map.addPopup(popup);
			popup.hide();
			
			
	});
		
	
