module AttachmentExtensions
  extend ActiveSupport::Concern
  
  module ClassMethods
    
  end
  
  module InstanceMethods

    def all_image_urls_exists?
      urls = styles.map{ |style| "#{Rails.root}/public/#{url(style.first, false)}" }
      urls.each { |url| return false unless File.exists?(url) }
      true
    end
  
    def biggest_image_url
      %w(gallery huge large medium small).each do |style|
        return url(style) if File.exists?("#{Rails.root}/public/#{url(style, false)}")
      end
      url
    end

  end
end

class Paperclip::Attachment
  include AttachmentExtensions
end