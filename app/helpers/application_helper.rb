module ApplicationHelper
  
  def title
    page_title = ["Antarctic Field Guides"]
    page_title << "Guides" if controller_name == 'guides'
    page_title << @guide.name if @guide
    page_title << "Landscapes" if controller_name == 'landscapes'
    page_title << @landscape.name if @landscape
    page_title << "Species" if controller_name == 'species'
    page_title << "#{@taxonomy.name} (#{@taxonomy.hierarchy})" if @taxonomy
    page_title << @species.name if @species && action_name == 'show'
    page_title.reverse.join(' - ')
  end
  
  def entry_css_class(entry)
    case entry.element_type
    when 'Guide'
      'single'
    when 'Species'
      'specie'
    when 'Landscape'
      'landscape'
    when 'Order'
      'amount'
    when 'Class'
      'amount'
    when 'Family'
      'amount'
    when 'Kingdom'
      'amount'
    when 'Phylum'
      'amount'
    else
      'single'
    end
  end
  
  def share_in_facebook(element)
    url = case element.class.to_s
    when 'Species'
      species_url(element)
    when 'Landscape'
      landscape_url(element)
    when 'Taxonomy'
      species_taxonomy_url(params)
    end
    "javascript:var%20d=document,f='http://www.new.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1219930092&u=#{CGI.escape(url)}&t='+e(d.title);1;try{if%20(!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z)%20{a=function()%20{if%20(!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=626,height=436'))l.href=f+p};if%20(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)"
  end
  
  def share_in_twitter(element)
    text, url = nil, nil
    case element.class.to_s
    when 'Species'
      text, url = element.full_name, species_url(element)
    when 'Landscape'
      text, url = element.name, landscape_url(element)
    when 'Taxonomy'
      text, url = "#{element.name} (#{element.hierarchy})", species_taxonomy_url(params)
    end
    "http://twitter.com/?status=#{CGI.escape("#{text} - #{url}")}"
  end
  
  def pop_up_flash
    return "" unless flash[:notice]
    content_tag(:div, :class => 'pop_up') do
      content_tag(:p) do
        content_tag(:span, raw(flash[:notice]) + link_to('', 'javascript: void closePopUp()', :class => 'close')) 
      end
    end
  end
  
  def flush_the_flash
    if flash[:alert]
      notice_div(flash[:alert], 'error')
    elsif flash[:notice]
      notice_div(flash[:notice], 'success')
    end
  end
  
  def notice_div(text, extra_class = nil)
    content_tag(:div, :class => 'flashes') do
      content_tag(:div, :class => [ 'message', extra_class ].join(' ')) do
        content_tag(:p, text)
      end
    end
  end

  def stars(element)
    content_tag(:p, :class => "star #{element.send(element.sort_by_attribute) == 0 ? 'zero' : ''}") do
      content_tag(:span) do
        image_tag("common/#{element.send(element.sort_by_attribute) == 0 ? 'gray' : 'pink'}_star.png", :alt=>"star") + element.send(element.sort_by_attribute).to_s
      end
    end
  end

  def css_class_if(condition, css_class)
    condition ? raw(" class=\"#{css_class}\"") : ''
  end  
  
  def expand_taxonomy_path(taxonomy)
    return if taxonomy.nil?
    case taxonomy.hierarchy
      when 'kingdom'
        breadcrumb = [:kingdom]
      when 'phylum'
        breadcrumb = [:kingdom, :phylum]
      when 'class'
        breadcrumb = [:kingdom, :phylum, :t_class]
      when 'order'
        breadcrumb = [:kingdom, :phylum, :t_class, :t_order]
      when 'family'
        breadcrumb = [:kingdom, :phylum, :t_class, :t_order, :family]
      when 'genus'
        breadcrumb = [:kingdom, :phylum, :t_class, :t_order, :family, :genus]
    end
    url_params = {}
    species = taxonomy.species
    return unless species
    breadcrumb.each do |param_name|
      url_params.merge!({param_name => species.send(param_name)})
    end
    species_taxonomy_path(url_params)
  end
  
end
