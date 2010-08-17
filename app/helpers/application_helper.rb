module ApplicationHelper
  
  def title
    page_title = ["Atlantic Field Guides"]
    page_title << "Guides" if controller_name == 'guides'
    page_title << @guide.name if @guide
    page_title.join(' - ')
  end
  
  def entry_css_class(entry)
    case entry.element_type
    when 'Guide'
      'single'
    when 'Species'
      'specie'
    when 'Landscapes'
      'landscape'
    else
      'single'
    end
  end
  
  def share_in_facebook(species)
    "javascript:var%20d=document,f='http://www.new.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1219930092&u=#{CGI.escape(species_url(species))}&t='+e(d.title);1;try{if%20(!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z)%20{a=function()%20{if%20(!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=626,height=436'))l.href=f+p};if%20(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)"
  end
  
  def share_in_twitter(species)
    "http://twitter.com/?status=#{CGI.escape("#{species.full_name} - #{species_url(species)}")}"
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
  
end
