module ApplicationHelper
  
  def title
    page_title = ["Atlantic Field Guides"]
    page_title << "Guides" if controller_name == 'guides'
    page_title << @guide.name if @guide
    page_title.join(' - ')
  end
  
end
