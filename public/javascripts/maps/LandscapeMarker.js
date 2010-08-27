
LandscapeMarker = OpenLayers.Class({
    

    icon: null,
    lonlat: null,
    events: null,
    map: null,

    initialize: function(lonlat, icon, info) {
        this.lonlat = lonlat;
        this.info = info;

        var newIcon = (icon) ? icon : OpenLayers.Marker.defaultIcon();
        if (this.icon == null) {
            this.icon = newIcon;
        } else {
            this.icon.url = newIcon.url;
            this.icon.size = newIcon.size;
            this.icon.offset = newIcon.offset;
            this.icon.calculateOffset = newIcon.calculateOffset;
        }
        this.events = new OpenLayers.Events(this, this.icon.imageDiv, null);
    },
    

    destroy: function() {
        // erase any drawn features
        this.erase();

        this.map = null;

        this.events.destroy();
        this.events = null;

        if (this.icon != null) {
            this.icon.destroy();
            this.icon = null;
        }
    },
    

    draw: function(px) {
				
				var me = this;
				
				$(this.icon.imageDiv).css('background','url(../images/map/landscape_bkg.png) no-repeat 0 0');
				$(this.icon.imageDiv).children().hide();
				$(this.icon.imageDiv).append('<a href="#" class="open" style="position:relative; float:left; width:100%; height:57px; "><img src="'+this.icon.url+'" style="position:relative; margin:5px 0 0 6px; width:70px; height:47px" /></a><div class="infowindow"><a href="#" class="close"></a><h1>'+this.info.name+'</h1><p class="star zero"><span><img alt="star" src="/images/common/gray_star.png" />'+ this.info.guides_count+'</span></p> <a href="'+ this.info.add_url +'" class="add">Add this guide</a></div>');
				
				if (this.info.guides_count!=0) {
					$(this.icon.imageDiv).find('p.star span img').attr('src','/images/common/pink_star.png');
					$(this.icon.imageDiv).find('p.star').removeClass('zero');
				}
				

				if (this.info.add_url == null || this.info.add_url == "") {
					$(this.icon.imageDiv).find('a.add').addClass('src','disabled');
					$(this.icon.imageDiv).find('a.add').removeAttr('href');
					$(this.icon.imageDiv).find('a.add').text('Already added');
				}
				
				
				if (this.info.description!=null && this.info.description!="") {
					$(this.icon.imageDiv).find('div.infowindow').append('<div class="info"><img class="background" src="'+ this.info.picture_large +'" /><span><p>'+this.info.description+'</p><a href="'+ this.info.url +'" class="more">Learn more</a></span></div>');
				} else {
					$(this.icon.imageDiv).find('div.infowindow').append('<img class="landscape" src="'+ this.icon.url +'" alt="'+this.info.name+'"/>');
				}

				
				$(this.icon.imageDiv).find('a.open').click(function(ev){
					ev.stopPropagation();
					ev.preventDefault();
					if (!$(me.icon.imageDiv).find('div').is(':visible')) {
						$('div.infowindow').hide();
						var position = map.getViewPortPxFromLonLat(me.lonlat);
						var move_y = 0;
						var move_x = 0;
						
						if (position.y<237) {
							move_y = -237+ position.y - 65;
						}
						
						if (position.x<125) {
							move_x = -125+position.x -30;
						}
						
						if (($('div#map').width() - position.x)<125) {
							move_x = 125 - ($('div#map').width() - position.x) + 30;
						}
						
						map.pan(move_x,move_y);
						$(me.icon.imageDiv).find('div').fadeIn('fast');
						
					}
				});
				
				$(this.icon.imageDiv).find('a.close').click(function(ev){
					ev.stopPropagation();
					ev.preventDefault();
					if ($(me.icon.imageDiv).find('div.infowindow').is(':visible')) {
						$('div.infowindow').fadeOut();
					}
				});
				
        return this.icon.draw(px);
    },


    erase: function() {
        if (this.icon != null) {
            this.icon.erase();
        }
    }, 


    moveTo: function (px) {
        if ((px != null) && (this.icon != null)) {
            this.icon.moveTo(px);
        }           
        this.lonlat = this.map.getLonLatFromLayerPx(px);
    },


    isDrawn: function() {
        var isDrawn = (this.icon && this.icon.isDrawn());
        return isDrawn;   
    },


    onScreen:function() {
        
        var onScreen = false;
        if (this.map) {
            var screenBounds = this.map.getExtent();
            onScreen = screenBounds.containsLonLat(this.lonlat);
        }    
        return onScreen;
    },
    

    inflate: function(inflate) {
        if (this.icon) {
            var newSize = new OpenLayers.Size(this.icon.size.w * inflate,
                                              this.icon.size.h * inflate);
            this.icon.setSize(newSize);
        }        
    },
    

    setOpacity: function(opacity) {
        this.icon.setOpacity(opacity);
    },


    setUrl: function(url) {
        this.icon.setUrl(url);
    },    


    display: function(display) {
        this.icon.display(display);
    },

    CLASS_NAME: "LandscapeMarker"
});



LandscapeMarker.defaultIcon = function() {
    var url = OpenLayers.Util.getImagesLocation() + "marker.png";
    var size = new OpenLayers.Size(21, 25);
    var calculateOffset = function(size) {
                    return new OpenLayers.Pixel(-(size.w/2), -size.h);
                 };

    return new OpenLayers.Icon(url, size, null, calculateOffset);        
};
    

