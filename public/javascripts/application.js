var modal_publish;
var over_activity = false;

AFG = {
	behaviour: function() {
		// AJAX pagination
		$('a.ajax').attr('data-remote', 'true');
	}
}

$(document).ready(function() {
	
	modal_publish = $('#publish_container').html();

	$('#search_term').example('Search species, guides,...');
	
	//Show pop_up
	var pop_up_width = parseInt($('div.pop_up').width())/2;
	$('#pop_up').css('margin-left','-'+ pop_up_width + 'px');
	$('#pop_up').delay(3000).fadeOut();
	

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
	$('#publish_container').html(modal_publish);
	$('#publish_container').modal(
		{onOpen: function (dialog) {
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



function firstStep(type) {
	
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
				var second_step = '<div class="long"><div class="type loading"><img class="loading" src="../images/modal/ajax-loader.gif" /></div><div class="info"><h5>Your Anctartic Field Guide is ready to download</h5><p>Please, be patient, this will take less than five minutes.</p><a class="disabled" href="#">Download</a></div></div>';
		    $('div.choice').html(second_step);
				$('div.choice').animate({
				    height: 'toggle'
				  }, 500, function() {
						$('div.choice').delay(4000).animate({
						    height: 'toggle'
						  }, 500, function() {
								var third_step = '<div class="long"><div class="type finished"><img class="image" src="" /><img class="ok" src="../images/modal/ok.png" /></div><div class="info"><h5>Your Anctartic Field Guide is ready to download</h5><p>If your download doesn’t start in five seconds, click the download button</p><a href="#">Download</a></div></div>';
								$('div.choice').html(third_step);
								$('div.choice').animate({
								    height: 'toggle'
								  }, 500);
						});
				});
		  });
}



function secondStep(type) {
	
	$('div#publish_container ul li').each(function(index,element){
		if (index==2) {
			$(this).addClass('active');
		} else {
			$(this).removeClass('active');
		}	});
	
	$('div.choice').animate({
	    height: 'toggle'
	  }, 500, function() {
			var second_step = '<div class="long"><div class="type loading"><img class="loading" src="../images/modal/ajax-loader.gif" /></div><div class="info"><h5>Your Anctartic Field Guide is ready to download</h5><p>Please, be patient, this will take less than five minutes.</p><a class="disabled" href="#">Download</a></div></div>';
	    $('div.choice').html(second_step);
			$('div.choice').animate({
			    height: 'toggle'
			  }, 500, function() {
					$('div.choice').delay(4000).animate({
					    height: 'toggle'
					  }, 500, function() {
							var third_step = '<div class="long"><div class="type finished"><img class="image" src="" /><img class="ok" src="../images/modal/ok.png" /></div><div class="info"><h5>Your Anctartic Field Guide is ready to download</h5><p>If your download doesn’t start in five seconds, click the download button</p><a href="#">Download</a></div></div>';
							$('div.choice').html(third_step);
							$('div.choice').animate({
							    height: 'toggle'
							  }, 500);
					});
			});
	  });
}


