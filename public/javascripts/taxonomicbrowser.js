var widthContent = "886px"
var maxColumn = 1;
var initDataLoaded = 0;
var numBreadCrumbs = 0;
var columnWidth = 292;
var clickOnHref = 0;
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
		
		// To get the event and redirect correctly to new page
		$('div.taxon_content div.in ul li div.text a.specie').live('click', function (event) {
			clickOnHref = 1;
		});
		// To get the event and redirect correctly to new page
		$('div.taxon_content div.in ul li div.text a.add').live('click', function (event) {
			clickOnHref = 1;
		});
		
		
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
			
			// if (data.rank != "species"){
				if (noColumn == 0){
					makeHtmlList(nextColumn,data);
					elementClicked = $('div.taxon_content div.in ul#column1 li').first();
					clickColumnFunction(null,elementClicked);
				}
				else {
					if ($('div.taxon_content div.in ul#column'+nextColumn).length==0) {					
						maxColumn = nextColumn;
						var posNextColumn = columnWidth*(nextColumn-1);

						if (nextColumn > 3){
							$('div.taxon_content div.in').css("width",(nextColumn*columnWidth)+10);
						}
						else {
							$('div.taxon_content div.in').css("width",widthContent);
						}

						$('div.taxon_content').delay(250).scrollTo((nextColumn)*columnWidth,{axis:'x'});

						$('div.taxon_content div.in').append('<ul id="column'+ nextColumn +'"></ul>');
						makeHtmlList(nextColumn,data);
					} else {					
						clearColumn(nextColumn);
						$('div.taxon_content div.in').append('<ul id="column'+ nextColumn +'"></ul>');
						makeHtmlList(nextColumn,data);
					}

					// All the init data is not loaded 
					if (initDataLoaded == 0) {
						initDataLoaded = 1;
						elementClicked = $('div.taxon_content div.in ul#column2 li').first();
						clickColumnFunction(null,elementClicked);
					}
				}	
			//}
		}
		
		function clickColumnFunction(event,element) {			
			// event.stopPropagation();
			// event.preventDefault();
			if ((!element.hasClass('specie'))&&(clickOnHref != 1)){
				var selectedColumn = getColumnID(element.parent().attr('id'));
				var nextColumn = parseInt(selectedColumn) + 1;

				var actual_index = element.index();

				var specie_selected = element.find('a.specie').text();

				// If is necessary to delete the rest of elements
				if (selectedColumn <= numBreadCrumbs) {

					var numElementsToDelete = numBreadCrumbs - (selectedColumn - 1);
					for (var i=0; i<numElementsToDelete; i++) {
						$('div#taxon_browser div.breadcrumbs ul li').last().remove();
						numBreadCrumbs -= 1;
					}
				}

				$('div#taxon_browser div.breadcrumbs ul li').each(function(index) {

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
					$('#taxon_browser div.breadcrumbs ul').append(htmlBreadCrumbs);					
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

					showActiveBkgBar(selectedColumn,actual_index);

					element.find('a.bttn_add').css('display','none');

					element.children().children('h3').css("color","#0099CC");
					getData(element.attr('id'),selectedColumn);
				}
			}
		}
		
		// end clickColumnFunction
		//clear all previous column
		function clearColumn(actualColumn) {
		
			for (var i=maxColumn; i>=actualColumn; i--) {
				$('div.taxon_content div.in ul').last().remove();
			}
			
			// Cleaning the actives bar
			for (var i=maxColumn; i>=actualColumn; i--) {
				$('#bkg_column'+i).css("display","none");
			}
			
			maxColumn = actualColumn;
			
			if (maxColumn > 3){
				$('div.taxon_content div.in').css("width",(maxColumn*columnWidth)+10);
			}
			else {
				$('div.taxon_content div.in').css("width",widthContent);
			}

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
			
			var list_item = '';
			var html = '';

			// Is the first column -> We have kingdoms
			result = result.childs;	

			if (result == null){
				$(li).children('div.text').children('a.bttn_add').css("display","none");
			}
			else {
				
				for(var i=0; i<result.length; i++) {
					
					var isSpecie = 0;
					
					var li = document.createElement("li");
					
					if (result[i].picture != null) {						
						isSpecie = 1;
						list_item = '<div class="image"><img src=""/></div><div class="text image"><h3><a class="specie" href="#"></a></h3><p><a href="#" class="add" data-remote="true">add</a></p></div> <div class="line"></div>';
					}else {
						list_item = '<div class="text"><h3><a class="specie" href="#"></a></h3><a class="bttn_add"></a><p><strong></strong> species, <a href="#" class="add" data-remote="true">add</a></p></div> <div class="line"></div>';
					}
					
					$(li).append(list_item);
					
					if (isSpecie == 1){
						$(li).children('div.image').css("display","inline");
						$(li).children('div.image').children('img').attr("src",result[i].picture);
					}
					
					if (result[i].name.length > 28) {
						result[i].name = result[i].name.substring(0,25) + "...";
					}

					$(li).children('div.text').children('h3').children('a').text(result[i].name);
					
					if (result[i].url != null) {
						$(li).children('div.text').children('h3').children('a').attr("href",result[i].url);	
					}
					else {
						$(li).children('div.text').children('h3').children('a').attr("href","/");	
					}
					var htmlText = "";
					// If is not added
					if (result[i].add_url != null) {
						
						if (isSpecie == 1){
							if (result[i].common_name != null){
								htmlText = result[i].common_name;
							}
							else {
								htmlText = result[i].name;
							}
							htmlText = htmlText + ', <a class="add" data-remote="true" href="'+ result[i].add_url+'">add</a>'; 
							$(li).children('div.text').children('p').html(htmlText);
						}
						else {
							$(li).children('div.text').children('p').children('strong').text(result[i].count);
							$(li).children('div.text').children('p').children('a.add').attr("href", result[i].add_url); 
						}

					}
					else {
						$(li).children('div.text').children('p').children('a.add').text("");
						$(li).children('div.text').children('p').children('a.add').css("display","none");
						
						if (isSpecie == 1){
							if (result[i].common_name != null){
								htmlText = result[i].common_name + ', added';
							}else {
								htmlText = result[i].name + ', added';
							}
							
						}else {
							htmlText = '<strong>'+ result[i].count + '</strong> species, added';  
						}
						
						$(li).children('div.text').children('p').html(htmlText);
					}

					
					$(li).attr('id',result[i].id);

					// if (i == 0) {
					// 	$(li).attr('class','first_column'+column);
					// }else if (i+1 == result.length){
					// 	$(li).attr('class','last_column'+column);
					// }
					if (isSpecie == 1){
						html = html+'<li id="'+$(li).attr('id')+'" class="specie">'+$(li).html()+'</li>';
					}else {
						html = html+'<li id="'+$(li).attr('id')+'">'+$(li).html()+'</li>';
					}
					
				}			
			}
			
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
			
			$('div.taxon_content div.in').append('<div id="bkg_column'+ column +'" class="active_column"></div>');
			
			var posColumn = (292 * column);
			$('#bkg_column'+column).css("left", posColumn +'px')
			$('#bkg_column'+column).css("display","inline");			
			
			var posRow = (60 * row) + 1;
			$('#bkg_column'+column).css("top", posRow +'px')
			$('#bkg_column'+column).css("display","inline");
			
			var nextColumnToDelete = parseInt(column) + 1;
			$('#bkg_column'+nextColumnToDelete).css("display","none");
		}
		
		$('div#taxon_browser div.breadcrumbs ul li p a').live('click',function(event){
			var id_Element = $(this).attr('id');
			var numOfBread = parseInt($(this).attr('id').substring(5,id_Element.length));

			if (numOfBread != 0) {
				numOfBread--;
			} 
			var offset = numOfBread * columnWidth;
			offset += 'px';
			
			$('div.taxon_content').delay(250).scrollTo(offset,{axis:'x'});
		}); // end click function
		
	}
})(jQuery);