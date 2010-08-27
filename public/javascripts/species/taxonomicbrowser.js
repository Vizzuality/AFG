var selectedColumn;
var selectedTaxonId;
var maxColumn = 1;
var numBreadCrumbs = 0;
var initDataLoaded = 0;

(function($){

  $.fn.taxonomicbrowser = function(){

		$('div.in').jScrollHorizontalPane({showArrows:true});

		// Simulate first row clicked, to the first and the second column
		createFirstColumn();

		$("div.in ul li").live(
		        'hover',
		        function (ev) {
		            if (ev.type == 'mouseover') {
		                $(this).find('a.bttn_add').css("background-position","0 -15px");
		            }
		            if (ev.type == 'mouseout') {
		                $(this).find('a.bttn_add').css("background-position","0 0");
		            }});

		$('div.in ul li').live('click',function(event){			
			clickColumnFunction(event,$(this));
		}); // end click function


	function getData(taxonID,columnID) {

		if (taxonID == "all") {			
			$.ajax({
	        method: 'GET',
	   		url: "/api/taxonomy",
	   		data: null,
	   		cache: false,
				dataType: 'json',
	   		success: function(result){
				addColumn(columnID,result,taxonID);
	   		},
	     	error:function (xhr, ajaxOptions, thrownError){
	      	console.log('TAXONOMIC' + xhr.status + "\n" + thrownError);
					return null;
	      }
			});
		}else {
			$.ajax({
	        type: 'GET',
	   		url: "/api/taxonomy?id="+taxonID,
	   		data: null,
	   		cache: false,
				dataType: 'json',
	   		success: function(result){
					addColumn(columnID,result,taxonID);
	   		},
	     	error:function (xhr, ajaxOptions, thrownError){
					return null;
	      	}
			});	
		}		
	}

	//add column or change data column
	function addColumn(noColumn,data,taxonID) {

		var nextColumn = parseInt(noColumn)+1;

		// console.log("columna: " + noColumn);

		if (noColumn == 0){
			makeHtmlList(nextColumn,data);
			elementClicked = $('ul#column1 li').first();
			clickColumnFunction(null,elementClicked);

		}else {

				if ($('#column'+nextColumn).length==0) {					
					maxColumn = nextColumn;
					var posNextColumn = 294*(nextColumn-1);
					$('div.in').append('<div class="holder scrollTaxon" style="left:'+posNextColumn+'px;"><ul class="jScrollPaneContainer jScrollPaneScrollable" id="column'+ nextColumn +'"></ul><div>');

					makeHtmlList(nextColumn,data);
				} else {					
					clearColumn(nextColumn);
					makeHtmlList(nextColumn,data);
				}

				// All the init data is not loaded 
				if (initDataLoaded == 0) {
					initDataLoaded = 1;
					elementClicked = $('ul#column2 li').first();
					clickColumnFunction(null,elementClicked);
				}

		}
	}

	//create html for the new column
	function makeHtmlList(column,result) {
		var list_item = '<div class="text"><h3><a class="specie" href="#"></a></h3><a href="#" class="bttn_add"></a><p><strong></strong> species, <a href="#" class="add">add</a></p></div> <div class="line_divided"></div>';
		var html = '';

		// Is the first column -> We have kingdoms
		result = result.childs;	


		if (result == null){
			$(li).children('div.text').children('a.bttn_add').css("display","none");
		}
		else {
			for(var i=0; i<result.length; i++) {

				if ((result[i].common_name!= null) && (result[i].picture != null)) {
					alert('llega al último');
				} 
				var li = document.createElement("li");

				$(li).append(list_item);

				if (result[i].name.length > 28) {
					result[i].name = result[i].name.substring(0,25) + "...";
				}

				$(li).children('div.text').children('h3').children('a').text(result[i].name);
				// URL del TAXON?

				if (result[i].url != null) {
					$(li).children('div.text').children('h3').children('a').attr("href",result[i].url);	
				}
				else {
					$(li).children('div.text').children('h3').children('a').attr("href","/");	
				}

				if (result[i].add_url != null) {
					$(li).children('div.text').children('p').children('a.add').attr("href", result[i].add_url); 
				}
				else {
					$(li).children('div.text').children('p').children('a.add').attr("href", "/"); 
				}

				$(li).children('div.text').children('p').children('strong').text(result[i].count);
				$(li).attr('id',result[i].id);

				if (i == 0) {
					$(li).attr('class','first_column'+column);
				}else if (i+1 == result.length){
					$(li).attr('class','last_column'+column);
				}

				html = html+'<li class="'+$(li).attr('class')+'" id="'+$(li).attr('id')+'">'+$(li).html()+'</li>';
			}			
		}

		console.log(html);

		$('ul#column'+ column).append(html);
		$('ul#column'+ column).jScrollPane({showArrows:false, scrollbarWidth: 15,topCapHeight:7, bottomCapHeight:7}); 

		// If we've results
		if (column > 2) {
			// TODO -> delay is necessary?
			$('div.in').delay(250).scrollTo('+=296px',{axis:'x'});
			$('div.in').css("overflow","auto");
		}
		else {
			// To hide the scrollbar if is not necessary
			$('div.in').css("overflow","hidden");
		}

	}


	//clear all previous column
	function clearColumn(actualColumn) {
		for (var i=actualColumn; i<=maxColumn; i++) {
			$('ul#column'+i).html('');
			$('ul#column'+i).jScrollPaneRemove();
		}
		maxColumn = actualColumn;
	}


	//get column id
	function getColumnID(str) {
		return str.substr(6,str.length-1);
	}

	function removePreviousSelected(selectedColumn) {
		$('ul#column'+selectedColumn+' li.selected_column'+selectedColumn).each(function(index){

			$(this).removeClass('selected_column'+selectedColumn);
			$(this).find('a.bttn_add').css('display','inline');
			$(this).children().children('h3').css("color","#0099CC");				
		});
	}

	function clickColumnFunction(event,element) {
		// event.stopPropagation();
		// event.preventDefault();

		var selectedColumn = getColumnID(element.parent().attr('id'));
		var nextColumn = parseInt(selectedColumn) + 1;

		var actual_index = element.index();

		$('div.taxon_content').css("width",nextColumn*296);

		var specie_selected = element.find('a.specie').text();

		// If is necessary to delete the rest of elements
		if (selectedColumn <= numBreadCrumbs) {

			var numElementsToDelete = numBreadCrumbs - (selectedColumn - 1);
			for (var i=0; i<numElementsToDelete; i++) {
				$('div.breadcrumbs ul li').last().remove();
				numBreadCrumbs -= 1;
			}
		}

		$('div.breadcrumbs ul li').each(function(index) {

			if ((parseInt($(this).index()) + 2 ==  selectedColumn)&&(selectedColumn != 1)) {
				$(this).removeClass('actual');
				var finalPosition = $(this).position().left + $(this).width() - 13;
				var htmlBreadCrumbs = '<li class="actual" style="left:'+ finalPosition + 'px"><p><a id="bread'+ selectedColumn +'">' + specie_selected + '</a></p></li>';
				$(this).parent().append(htmlBreadCrumbs);					
				numBreadCrumbs += 1;
			}

	  	});

		if (numBreadCrumbs == 0) {				
			var htmlBreadCrumbs = '<li class="first actual" style="left:0px"><p><a id="bread0">' + specie_selected + '</a></p></li>';
			$('div.breadcrumbs ul').append(htmlBreadCrumbs);					
			numBreadCrumbs += 1;	
		}

		// To show the line to divide each li
		$('ul#column'+selectedColumn+' li').each(function(index) {
		    if (index != actual_index) {
				element.children('div.line_divided').show();
			}	
	  	});

		// Hide the previous and actual line to divide
		if (actual_index != 0) {
			$('ul#column'+selectedColumn+' li').eq(actual_index-1).children('div.line_divided').hide();
			$('ul#column'+selectedColumn+' li').eq(actual_index).children('div.line_divided').hide();
		}

		if (!element.hasClass('selected_column'+selectedColumn)) {
			removePreviousSelected(selectedColumn);

			element.addClass('selected_column'+selectedColumn);

			element.find('a.bttn_add').css('display','none');

			element.children().children('h3').css("color","#0099CC");
			getData(element.attr('id'),selectedColumn);
		}
	}
	// end clickColumnFunction

	function createFirstColumn() {
		// 13140803 is the id to test it -> to change for search "all data" 
		getData("all",0);
	}

	$('div.breadcrumbs ul li p a').live('click',function(event){

		var id_Element = $(this).attr('id');
		var numOfBread = parseInt($(this).attr('id').substring(5,id_Element.length));
		var offset = numOfBread * 296;
		offset += 'px';

		$('div.in').delay(250).scrollTo(offset,{axis:'x'});
	}); // end click function




}
})(jQuery);