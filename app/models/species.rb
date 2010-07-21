# == Schema Information
#
# Table name: species
#
#  id             :integer         not null, primary key
#  uid            :integer         
#  permalink      :string(255)     
#  name           :string(255)     
#  guides_count   :integer         default(0)
#  genus          :string(255)     
#  family         :string(255)     
#  common_name    :string(255)     
#  description    :text            
#  identification :string(255)     
#  distribution   :text            
#  ecology        :text            
#  size           :text            
#  depth          :text            
#  reference      :text            
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Species < ActiveRecord::Base
    
  has_many :entries
  has_many :guides, :through => :entries
  has_many :pictures
  
  validates_presence_of :name
  
  before_validation :set_permalink
  
  scope :from_family, Proc.new{ |family| where(:family => family) }

  def to_param
    "#{id}-#{permalink}"
  end
  
  def picture
    pictures.try(:first)
  end
  
  def self.families
    Species.select("family").map(&:family).uniq.sort
  end
  
  def self.find_by_term(q)
    escaped_q = sanitize_sql(q)
    where("name like '%#{escaped_q}%' OR genus like '%#{escaped_q}%' OR description like '%#{escaped_q}%'")
  end

  private
  
    def set_permalink
      return unless self.permalink.blank?
      self.permalink = name.sanitize
      temporal_permalink = permalink
      if self.class.exists?(:permalink => temporal_permalink)
        i = 2
        temporal_permalink = permalink + "-#{i}"
        while(self.class.exists?(:permalink => temporal_permalink)) do
          i+=1
          temporal_permalink = permalink + "-#{i}"
        end
        self.permalink = temporal_permalink
      end
    end
  
end
