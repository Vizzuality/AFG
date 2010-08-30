var maxColumn = 1;
var initDataLoaded = 0;
var numBreadCrumbs = 0;
var columnWidth = 292;

(function($){
	
	$.fn.taxonomicbrowser = function(){
		
		// Simulate first row clicked, to the first and the second column
		createFirstColumn();
		
		function createFirstColumn() {
			getData("all",0);
		}
		
		// hOver each li (showing the action to do it)
		$("div.taxon_content div.in ul li").live(
		        'hover',
		        function (ev) {
		            if (ev.type == 'mouseover') {
		                $(this).find('a.bttn_add').css("background-position","0 -15px");
		            }
		            if (ev.type == 'mouseout') {
		                $(this).find('a.bttn_add').css("background-position","0 0");
		            }});
		
		// li is clicked
		$('div.taxon_content div.in ul li').live('click',function(event){			
			clickColumnFunction(event,$(this));
		}); // end click function
		
		// Call for data
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
			}
			else {
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

			if (noColumn == 0){
				makeHtmlList(nextColumn,data);
				elementClicked = $('div.taxon_content div.in ul#column1 li').first();
				clickColumnFunction(null,elementClicked);
			}
			else {
				if ($('div.taxon_content div.in ul#column'+nextColumn).length==0) {					
					maxColumn = nextColumn;
					var posNextColumn = columnWidth*(nextColumn-1);
					$('div.taxon_content div.in').append('<ul id="column'+ nextColumn +'"></ul>');
					makeHtmlList(nextColumn,data);
				} else {					
					clearColumn(nextColumn);
					makeHtmlList(nextColumn,data);
				}

				// All the init data is not loaded 
				if (initDataLoaded == 0) {
					initDataLoaded = 1;
					elementClicked = $('div.taxon_content div.in ul#column2 li').first();
					clickColumnFunction(null,elementClicked);
				}
			}
		}
		
		function clickColumnFunction(event,element) {
			// event.stopPropagation();
			// event.preventDefault();

			var selectedColumn = getColumnID(element.parent().attr('id'));
			var nextColumn = parseInt(selectedColumn) + 1;

			var actual_index = element.index();

			if (nextColumn > 3){
							$('div.taxon_content div.in').css("width",(nextColumn*columnWidth)+10);
						}
						else {
							$('div.taxon_content div.in').css("width","886px");
						}
			
			
			var specie_selected = element.find('a.specie').text();

			// If is necessary to delete the rest of elements
			if (selectedColumn <= numBreadCrumbs) {

				var numElementsToDelete = numBreadCrumbs - (selectedColumn - 1);
				for (var i=0; i<numElementsToDelete; i++) {
					$('div.taxon_content div.breadcrumbs ul li').last().remove();
					numBreadCrumbs -= 1;
				}
			}

			$('div.taxon_content div.breadcrumbs ul li').each(function(index) {

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
				$('div.taxon_content div.breadcrumbs ul').append(htmlBreadCrumbs);					
				numBreadCrumbs += 1;	
			}

			// To show the line to divide each li
			$('div.taxon_content div.in ul#column'+selectedColumn+' li').each(function(index) {
			    if (index != actual_index) {
					element.children('div.line').show();
				}	
		  	});

			// Hide the previous and actual line to divide
			if (actual_index != 0) {
				$('ul#column'+selectedColumn+' li').eq(actual_index-1).children('div.line').hide();
				$('ul#column'+selectedColumn+' li').eq(actual_index).children('div.line').hide();
			}

			if (!element.hasClass('active'+selectedColumn)) {
				removePreviousSelected(selectedColumn);

				element.addClass('active');
				
				showActiveBkgBar(selectedColumn,actual_index,element);
				
				element.find('a.bttn_add').css('display','none');

				element.children().children('h3').css("color","#0099CC");
				getData(element.attr('id'),selectedColumn);
			}
		}
		
		// end clickColumnFunction
		//clear all previous column
		function clearColumn(actualColumn) {
			for (var i=actualColumn; i<=maxColumn; i++) {
				$('ul#column'+i).html('');
				// $('ul#column'+i).jScrollPaneRemove();
			}
			maxColumn = actualColumn;
		}
		
		//get column id
		function getColumnID(str) {
			return str.substr(6,str.length-1);
		}
		
		function removePreviousSelected(selectedColumn) {
			$('ul#column'+selectedColumn+' li.active').each(function(index){
				$(this).removeClass('active');
				$(this).find('a.bttn_add').css('display','inline');
				$(this).children().children('h3').css("color","#0099CC");
			});
		}
		
		//create html for the new column
		function makeHtmlList(column,result) {
			var list_item = '<div class="text"><h3><a class="specie" href="#"></a></h3><a href="#" class="bttn_add"></a><p><strong></strong> species, <a href="#" class="add">add</a></p></div> <div class="line"></div>';
			var html = '';

			// Is the first column -> We have kingdoms
			result = result.childs;	

			if (result == null){
				$(li).children('div.text').children('a.bttn_add').css("display","none");
			}
			else {
				
				for(var i=0; i<result.length; i++) {
					if ((result[i].common_name!= null) && (result[i].picture != null)) {
						// alert('llega al último');
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

					// if (i == 0) {
					// 	$(li).attr('class','first_column'+column);
					// }else if (i+1 == result.length){
					// 	$(li).attr('class','last_column'+column);
					// }
					
					html = html+'<li id="'+$(li).attr('id')+'">'+$(li).html()+'</li>';
				}			
			}
			
			console.log(html);
			if (column > 2){
				$('ul#column'+ column).addClass('any_column');
			}
			$('ul#column'+ column).append(html);
			
			// If we've results

			var columnScroll = '+=' + columnWidth + 'px'
			// TODO -> delay is necessary?
			$('div.in').delay(250).scrollTo(10000,{axis:'x'});

		}
		
		function showActiveBkgBar (column,row,element){
			
			
			
			console.log('columna ' +column+ 'row '+ row + 'element ' + element.html());
			var posRow = (60 * row) + 1;
			$('#bkg_column'+column).css("top", posRow +'px')
			$('#bkg_column'+column).css("display","inline");
			
			var nextColumnToDelete = parseInt(column) + 1;
			$('#bkg_column'+nextColumnToDelete).css("display","none");
			// Para el left:
			// left: 292px no de columna 
		}
		
		$('div.breadcrumbs ul li p a').live('click',function(event){

			var id_Element = $(this).attr('id');
			var numOfBread = parseInt($(this).attr('id').substring(5,id_Element.length));
			var offset = numOfBread * columnWidth;
			offset += 'px';

			$('div.in').delay(250).scrollTo(offset,{axis:'x'});
		}); // end click function

	}
})(jQuery);