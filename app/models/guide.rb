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
#  highlighted     :boolean         
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Guide < ActiveRecord::Base
  
  scope :published, where("session_id is null")
  scope :highlighted, where("highlighted = ?", true)
  
  scope :sort_by_most_recent, order("created_at DESC")
  scope :sort_by_popularity, order("popularity DESC")
  
  def published?
    session_id.nil?
  end
  
end
