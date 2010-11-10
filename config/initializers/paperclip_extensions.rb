require 'attachment_extensions'

Paperclip.interpolates :image_file_name do |attachment, style|
  attachment.instance.image_file_name
end