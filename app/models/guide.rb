# == Schema Information
#
# Table name: guides
#
#  id              :integer         not null, primary key
#  name            :string(255)     
#  author          :string(255)     
#  description     :text            
#  species_count   :integer         default(0)
#  downloads_count :integer         default(0)
#  session_id      :string(255)     
#  popularity      :integer         default(0)
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Guide < ActiveRecord::Base
  
end
