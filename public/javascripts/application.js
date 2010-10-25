var modal_publish;
var over_activity = false;
var imageGuide;
var DESCRIPTION_MAX_LENGTH = 400;
var ALLOWED_KEYS = [8, 37, 38, 39, 40, 46];
AFG = {
	behaviour: function() {
		// AJAX pagination
		$('a.ajax').attr('data-remote', 'true');
	}
}

$(document).ready(function() {

	
	modal_publish = $('#publish_container').html();

	$('#search_term').example('Search species, guides,...');
	
	// To show the images
	$('a.lightbox').lightBox();
	
	//Search choices
	$('div.right div.results ul li').each(function(index){
		$(this).children('a').removeClass('all');
	});
	
	var first = getUrlVars()["type"];
	switch (first) {
		case 'species': $('div.right div.results ul li:eq(0) a').addClass('all');
				break;
		case 'guides': $('div.right div.results ul li:eq(2) a').addClass('all');
				break;
		case 'landscapes': $('div.right div.results ul li:eq(1) a').addClass('all');
				break;
		default: $('div.right div.results ul li:eq(3) a').addClass('all');
	}
	
	
	//Build count filter search
	var list_count = parseInt($('div.right div.results ul').attr('class'));
	$('div.right div.results ul li').each(function(index){
		if ($(this).attr('class')=='0') {
			$(this).children('a').css('background-position','0 -200px');
			$(this).children('a').children('span').css('background-position','0 -200px');
		} else {
			$(this).children('a').children('span').css('background-position','-'+((1*parseInt($(this).attr('class')))/list_count) + 'px 0px');
			$(this).children('a').children('span').css('background-position','-1px 0px');
		}
	});
	
	
	//Show pop_up
	 $('#pop_up').delay(3000).fadeOut();
	
	
	$('div.long div.long_in ul li.dragg_here a').hover(function(ev){
		$(this).parent().css('background-position','0 -127px');
	},
	function(ev){
		$(this).parent().css('background-position','0 0');
	});
	
	//Landscapes and species count bars in Species pages
	$('div.right div.stats span').each(function(index){
		var kind = $(this).attr('title');
		if (kind=='specie') {
			var color = '#FFFFFF';
		} else {
			var color = '#FFFFFF';
		}
		var count = $(this).attr('class');
		var x10 = parseInt((count)/10).toFixed(0);
		var mod = parseInt((count) % 10);
		$(this).html('<ul class="stats none" style="clear:both; width:10px; overflow:hidden"><li></li><li></li><li></li><li></li><li></li></ul>');
		for (var i=4; i>=0; i--) {
			if (x10>0) {
				$(this).find('li:eq('+i+')').html('<span style="float:left; width:10px; height:2px; background:'+color+'"></span>');
				x10--;
			} else {
				if (mod!=0) {
					$(this).find('li:eq('+i+')').html('<span style="float:left; width:'+mod+'px; height:2px; background:'+color+'"></span>');
					mod=0;
				}
			}
		}
	});

	//Landscapes and species count bars
	$('li div.stats span').each(function(index){
		
		var kind = $(this).attr('title');
		if (kind=='specie') {
			var color = '#FFB498';
		} else {
			var color = '#3FB2D9';
		}
		var count = $(this).attr('class');
		var x10 = parseInt((count)/10).toFixed(0);
		var mod = parseInt((count) % 10);
		$(this).html('<ul class="stats" style="clear:both; width:10px; overflow:hidden"><li></li><li></li><li></li><li></li><li></li></ul>');
		for (var i=4; i>=0; i--) {
			if (x10>0) {
				$(this).find('li:eq('+i+')').html('<span style="float:left; width:10px; height:2px; background:'+color+'"></span>');
				x10--;
			} else {
				if (mod!=0) {
					$(this).find('li:eq('+i+')').html('<span style="float:left; width:'+mod+'px; height:2px; background:'+color+'"></span>');
					mod=0;
				}
			}
		}
	});
	
	
	// IF USER IS OVER LATEST ACTIVITY, STOP MOVING LIST
	$('div.latest_ ul').hover(function(ev){
		over_activity = true;
	},
	function(ev){
		over_activity = false;
	});
	
	
	//hover species list effect >> HOME
	$('div.left ul li div.specie').hover(function(ev){
		$(this).css('background-position','-4px -175px');
	},
	function(ev){
		$(this).css('background-position','-4px -4px');
	});
	
	//hover created list effect >> HOME
	$('div.left div.create ul.published_afg li').hover(function(ev){
		$(this).css('background-position','-2px -175px');
	},
	function(ev){
		$(this).css('background-position','-2px -2px');
	});
	
	//list effect latest activity >> HOME
	setInterval("changeList()",3000);
	
	//hover created list effect >> GUIDES
	$('div.header_guides div.content ul li').hover(function(ev){
		$(this).css('background-position','0px -177px');
	},
	function(ev){
		$(this).css('background-position','0 -2px');
	});
	
	// click sorted box  >> GUIDES
	$('div.sorted_by a.sorted_box_deactivated').live('click',function(ev){
		ev.stopPropagation();
		ev.preventDefault();
		$(this).parent().find('div.activated_box').show();

	});

	// click sorted box  >> GUIDES
	$('div.activated_box a.sorted_box_activated').live('click',function(ev){
		ev.stopPropagation();
		ev.preventDefault();
		$(this).parent().fadeOut();
	});
	

	//hover created list effect >> EXPLORE
	$('div.most_popular_explore div.content ul li').hover(function(ev){
		$(this).css('background-position','0px -177px');
	},
	function(ev){
		$(this).css('background-position','0 -2px');
	});
	
	AFG.behaviour();	
 });


$(window).load(function() {
	//gallery effect >> HOME
	$('#slider').nivoSlider({effect:'fold'});
});



//Lastest Activity function >> HOME
function changeList() {
	if (!over_activity) {
		$('div.right div.latest_ ul li:first div').removeClass('first');
		$('div.right div.latest_ ul li:eq(4) div').animate({opacity: 0}, 700);
		var last_li = $('div.right div.latest_ ul li:last').html();
		$('div.right div.latest_ ul li:last').remove();
		$('div.right div.latest_ ul').prepend('<li style="height:0;"></li>');
		$('div.right div.latest_ ul li:first').animate({
		    height: 67
		  }, 700, function() {
		    $('div.right div.latest_ ul li:first').html(last_li);
				$('div.right div.latest_ ul li:first div').css('opacity','0');
				$('div.right div.latest_ ul li:first div').addClass('first');
				$('div.right div.latest_ ul li:first div').animate({opacity: 1}, 700);
		});
	}
}

//Pop up close action
function closePopUp() {
	$('#pop_up').fadeOut();
}

//Modal publish window
function openPublish() {
	$.get("/guides/update/current", { reset: "true"} );
	$('#publish_container').html(modal_publish);
	$('#publish_container').modal(
		{closeHTML: '<a class="modalCloseImg" title="Close"></a>',
			onOpen: function (dialog) {
						 	dialog.overlay.fadeIn('slow', function () {
								dialog.data.hide();
								dialog.container.fadeIn('slow', function () {
									dialog.data.fadeIn('slow');
								});
							});
						 },
		onClose: 	function (dialog) {
								dialog.data.fadeOut('fast', function () {
									dialog.container.hide('fast', function () {
										dialog.overlay.fadeOut('fast', function () {
											$.modal.close();
										});
									});
								});
							}
	});
}

function firstStep(type,argumentImageGuide) {
	imageGuide = argumentImageGuide;
	
	if(type == 'simple') {
		$.get("/guides/update/current", { guide_format: "checklist"} );
	} else {
		$.get("/guides/update/current", { guide_format: "complete"} );
	}
	
	$('div#publish_container ul li').each(function(index,element){
		if (index==1) {
			$(this).addClass('active');
		} else {
			$(this).removeClass('active');
		}
	});
		
	$('div.choice').animate({
	    height: 'toggle'
	  }, 500, function() {
		
		var first_step = '<form id="publish_current_guide" action="/guides/update/current"><div class="dont_want_publish"><label for="no_publish"><input id="no_publish" type="radio" name="publish" value="no" />I don’t want to publish my Field Guide</label></div>'+
		'<div class="want_publish active"><label for="publish"><input id="publish" type="radio" name="publish" value="yes" checked="checked"/>I want to publish my Antarctic Field Guide</label>'+
		'<div class="fill"><p class="subtitle">The AFG will have a dedicated page like that, and it will be downloable by other users</p>' +
		'<span><label>YOUR NAME</label></span><input type="text" id="author" name="author"/><span>'+
		'<label>GUIDE TITLE</label></span><input type="text" id="name" name="name"/><span>'+
		'<label>DESCRIPTION</label>'+
		'<p class="counter"><span>'+ DESCRIPTION_MAX_LENGTH +'</span> characters left</p>'+
		'<textarea name="description" id="description"></textarea></div></div>'+
		'<div class="errors"><span id="alert_name" class="alert"></span><div id="error_invalid_name"><p>The name of the guide can\'t be blank</p></div></div>' +
		'<div class="errors"><span id="alert_author" class="alert"></span><div id="error_invalid_author"><p>The author of the guide can\'t be blank</p></div></div>' +
		'<a href="javascript:void secondStep()" class="download">Proceed to download</a>';

  $('div.choice').html(first_step);
  $('textarea#description')
  .keyup(function(){
    // If description length is greater than allowed max, we truncate it
    if ($(this).val() && $(this).val().length > DESCRIPTION_MAX_LENGTH) {
      $(this).val($(this).val().substr(0, DESCRIPTION_MAX_LENGTH));
    };
    this.characters_left = DESCRIPTION_MAX_LENGTH - $(this).val().length;
    $('textarea#description').prev('p.counter').find('span').text(this.characters_left);
  })
  .keypress(function(evt){
    // Checks if pressed key is an allowed one
    if ($.inArray((evt.which ? evt.which : evt.keyCode), ALLOWED_KEYS) < 0) {
      // Can't add more characters to description if has reached max value of allowed chars.
      if (!this.characters_left || this.characters_left == 0 ) { evt.preventDefault(); return false;};
    };
  })
  .change(function(){
    if ($(this).val() && $(this).val().length >= DESCRIPTION_MAX_LENGTH) {
      $(this).val($(this).val().substr(0, DESCRIPTION_MAX_LENGTH));
    };
  });

	$('div.choice').find('a.download').css('display','none');
	$('div.choice').css('height','440px');
	$('div.choice').animate({
		height:'toggle'
		}, 500, function(){
			$(this).find('a.download').fadeIn('fast');
		});  
	});

}

// Changing the effects 
$('input#no_publish').live('click',function(ev){
	$(this).parent().parent().addClass('active');		
	$(this).parent().parent().parent().children('div.want_publish').removeClass('active');	
	$(this).parent().parent().parent().children('div.want_publish').children('div.fill').css('display','none');	
	$('#alert_name').hide();
	$('#alert_author').hide();
	$('#error_invalid_name').hide();
	$('#error_invalid_author').hide();
	
	$('div.choice').animate({
	    height: '140px'
	  }, 500);
});

// Changing the effects 
$('input#publish').live('click',function(ev){
	
	$('div.choice').find('a.download').css('display','none');
	$(this).parent().parent().addClass('active');	
	$(this).parent().parent().children('div.fill').css('display','inline');
	$(this).parent().parent().parent().children('div.dont_want_publish').removeClass('active');

	
	$('div.choice').animate({
		height:'440px'
		}, 500, function(){
			$(this).parent().parent().addClass('active');	
			$(this).parent().parent().children('div.fill').css('display','inline');
			$(this).parent().parent().parent().children('div.dont_want_publish').removeClass('active');			
			$(this).find('a.download').fadeIn('fast');
		});
});

function secondStep() {
	$('#alert_name').hide();
	$('#alert_author').hide();
	$('#error_invalid_name').hide();
	$('#error_invalid_author').hide();
	
	var publish = true;
	
	if($('#no_publish').attr('checked') == true) {
		$('div.choice').find('a.download').fadeOut('fast');
		$('div.choice').css('height','180px');
		publish = false;
	}
	
	var author = $('#author').val();
	var name = $('#name').val();

	if(publish == true) {
		var error = 0;
		
		if(author == "") {
  			$('#alert_author').fadeIn();
			$('#error_invalid_author').fadeIn();
			error = 1;
		}
		if(name == "") {
  			$('#alert_name').fadeIn();
			$('#error_invalid_name').fadeIn();
			error = 1;
		}
		if (error == 1) return false;
	}
	
	var dataString = 'description='+ $('#description').val() + '&author=' + author + '&name=' + name + '&publish=' + publish+'&print=true';
	
	var pdf_path = null;
	
	$.ajax({
    type: "POST",
    url: "/guides/update/current",
    data: dataString,
		error:function(xhr, ajaxOptions, thrownError){
			$('div.choice div.info a').click(function(){
				$.modal.close();
			});
			$('div.choice div.type').removeClass('loading');
			$('div.choice div.type').addClass('finished');
			$('div.choice div.type img').remove();
			$('div.choice div.info').addClass('error');
			$('div.choice div.info h5').text('Your Anctartic Field Guide couldn\'t be generated due to an error');
			$('div.choice div.info p').text("Please try again or contact with the administrators");
			$('div.choice div.info a').html('Close');
			$('div.choice div.info a').removeClass('disabled');
		},
	  success: function(res) {
			var object = JSON.parse(res);
			$('#pdf_path').attr('href',object['href']);
			$('#pdf_path').click(function(){
				$.modal.close();
			});
			$('div.choice div.type').removeClass('loading');
			$('div.choice div.type').addClass('finished');
			$('div.choice div.type img').remove();
			if (imageGuide != "nil"){
				$('div.choice div.type').append('<img class="image" src="' + imageGuide +'" /><img class="ok" src="/images/modal/ok.png" />');	
			}else {
				$('div.choice div.type').append('<img class="ok" src="/images/modal/ok.png" />');	
			}
			
			$('div.choice div.info h5').text('Your Anctartic Field Guide is ready');
			$('div.choice div.info p').text("The file you are about to download is a PDF. If you dont't have a reader, use this one.");
			$('div.choice div.info a').removeClass('disabled');
			$('div.choice div.info a').addClass('ready');			
		}
   });

	$('div#publish_container ul li').each(function(index,element){
		if (index==2) {
			$(this).addClass('active');
		} else {
			$(this).removeClass('active');
		}	
	});
	
	$('div.choice').animate({ height: 'toggle' }, 500, function() {
		var second_step = '<div class="long"><div class="type loading"><img class="loading" src="/images/modal/ajax-loader.gif" /></div>'+
		'<div class="info"><h5>We are processing your Antarctic Field Guide</h5><p>Please, be patient, this will take less than five minutes.</p>'+
		'<a class="disabled" id="pdf_path" href="javascript:void(null)">Download</a></div></div>';
    $('div.choice').html(second_step);
		$('div.choice').animate({
		    height: 'toggle'
		  }, 500, function() {
				setTimeout(function(){
				},3000);
		});
		$('#pdf_path').click(function(){
			$.modal.close();
		});
	});
}

function getUrlVars() {
	var vars = {};
	var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
		vars[key] = value;
	});
	return vars;
}


function goTo(place) {
	$.scrollTo("#"+place, 500);
}
