var modal_publish;

AFG = {
	behaviour: function() {
		// AJAX pagination
		$('a.ajax').attr('data-remote', 'true');
	}
}

$(document).ready(function() {
	
	modal_publish = $('#publish_container').html();

	$('#search_term').example('Search species, guides,...');
	$('#pop_up').delay(3000).fadeOut();
	
	// dragg elements >> ALL PAGES
	// $(function() {
	// 	$("#sortable").sortable({items: 'li:not(.dragg_here)',placeholder: 'place_draggable',tolerance: 'pointer'});
	// 	$("#sortable").disableSelection();
	// });
	
	// Text shadow for IE >> MODAL
	// $('#publish_container li.active span').textShadow({
	// 	color:   "#000",
	// 	xoffset: "5px",
	// 	yoffset: "5px",
	// 	radius:  "5px",
	// 	opacity: "50"
	// });
	
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


