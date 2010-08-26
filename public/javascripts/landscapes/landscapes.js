OpenLayers.DOTS_PER_INCH = 90.71428571428572;
OpenLayers.Util.onImageLoadErrorColor = 'transparent';
var map, popup;


	$(document).ready(function() {
		
		$.getJSON('/api/maps/features', function(data){
			//console.log(data);
			
			var mapOptions = { 
				resolutions: [50694.68146875, 25347.340734375, 12673.6703671875, 6336.83518359375, 3168.417591796875, 1584.2087958984375, 792.1043979492188, 396.0521989746094, 198.0260994873047, 99.01304974365235, 49.50652487182617, 24.753262435913086, 12.376631217956543, 6.188315608978272, 3.094157804489136, 1.547078902244568, 0.773539451122284, 0.386769725561142, 0.193384862780571, 0.0966924313902855, 0.04834621569514275, 0.024173107847571373, 0.012086553923785687, 0.006043276961892843, 0.0030216384809464217],
				projection: new OpenLayers.Projection('EPSG:3031'),
				maxExtent: new OpenLayers.Bounds(-6267731.972,-5502339.632,6710106.484,7475498.824),
				units: "meters",
				numZoomLevels:3,
				controls: [],
				restrictedExtent: new OpenLayers.Bounds(-6267731.972,-5502339.632,4885097.951125,5270280.1801067)
			};


			map = new OpenLayers.Map('map', mapOptions );
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
			
			
			
	    //Control double click handler
	    var dblclick = new OpenLayers.Handler.Click(this, {dblclick: function() { if (map.getZoom()<4) {map.zoomIn()} }, click: null }, {single: true, 'double': true, stopSingle: false, stopDouble: true});
	    dblclick.setMap(map);
	    dblclick.activate();
			
			
			
			var markers = new OpenLayers.Layer.Markers( "Markers" );
			map.addLayer(markers);
			
			var size = new OpenLayers.Size(5,5);
			var offset = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
			var occurrence = new OpenLayers.Icon('../images/map/occurrence.png',size,offset);
						
			for (var i=0; i<data.occurrences.length; i++) {
				var occurrence_marker = new OpenLayers.Marker(new OpenLayers.LonLat(data.occurrences[i].lon, data.occurrences[i].lat),occurrence.clone());
				markers.addMarker(occurrence_marker);
			}
			
			
			var size = new OpenLayers.Size(81,63);
			var offset = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
			
			for (var i=0; i<data.landscapes.length; i++) {
				var landscape_image = new OpenLayers.Icon(data.landscapes[i].picture,size,offset);
				var landscape_marker = new LandscapeMarker(new OpenLayers.LonLat(data.landscapes[i].lon,data.landscapes[i].lat),landscape_image); // data.landscapes[i].picture, size, offset
				markers.addMarker(landscape_marker);
			}
			
			
			
			// var markers = new OpenLayers.Layer.Markers( "Markers" );
			// 			map.addLayer(markers);
			// 			var size = new OpenLayers.Size(32,32);
			// 			var offset = new OpenLayers.Pixel(-(size.w/2), -(size.h/2));
			// 			var icon = new OpenLayers.Icon('http://maps.google.com/mapfiles/kml/pal2/icon0.png',size,offset);
			// 			
			// 			
			// 			var marker = new OpenLayers.Marker(new OpenLayers.LonLat(50694.68146875, 25347.340734375),);
			// 			var marker2 = new OpenLayers.Marker(new OpenLayers.LonLat(6.188315608978272, 3.094157804489136));
			// 			
			// 			markers.addMarker(marker);
			// 			markers.addMarker(marker2);
			// 			
			// 			
			// 			markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-589927.6475,3419924.3065),icon));
			//-589927.6475,3419924.3065,221187.256,4231039.21
			//markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(221187.256,4231039.21),icon));
			//markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(0,0),icon));
			//markers.events.register("click", markers, click);
			//popup = new OpenLayers.Popup.Anchored("chicken", new OpenLayers.LonLat(0,7), new OpenLayers.Size(200,200), "example popup", {size: new OpenLayers.Size(200,200), offset: new OpenLayers.Pixel(100,-400)});
			
      
			// map.addPopup(popup);
			// popup.hide();
			
			
		});

	});
	
	
	 // function click(evt) {
	 // 			console.log(evt);
	 // 			popup.moveTo(new OpenLayers.Pixel(evt.x,evt.y));
	 // 			popup.show();
	 //       popup.setBackgroundColor("yellow");
	 //  			popup.setOpacity(0.7);
	 // 			popup.setContentHTML('<p style="color:red; font:normal 20px Arial">jamon</p>');
	 // 			Event.stop(evt);
	 //     }



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
			} else {
				$('div.map').attr('style','position:relative; float:left; margin:20px 0 0 0; width:880px; height:373px; padding:8px 15px 13px; background:url(../images/common/map_bkg_shadow.png) no-repeat 5px bottom;');
				$('body').css('overflow','auto');
			}
		}
		
	
