# == Schema Information
#
# Table name: guides
#
#  id               :integer         not null, primary key
#  permalink        :string(255)     
#  name             :string(255)     
#  author           :string(255)     
#  description      :text            
#  species_count    :integer         default(0)
#  landscapes_count :integer         default(0)
#  downloads_count  :integer         default(0)
#  session_id       :string(255)     
#  popularity       :integer         default(0)
#  highlighted      :boolean         
#  published        :boolean         
#  created_at       :datetime        
#  updated_at       :datetime        
#

class Guide < ActiveRecord::Base
  
  validates_presence_of :author, :if => Proc.new{ |guide| guide.published? }
  validates_presence_of :name, :if => Proc.new{ |guide| guide.published? }

  has_many :entries, :order => 'created_at DESC'
  
  scope :published,       where("published = ?", true)
  scope :highlighted,     published.where("highlighted = ?", true)
  scope :not_highlighted, published.where("highlighted = ?", false)
  
  scope :sort_by_most_recent, order("created_at DESC")
  scope :sort_by_popularity,  order("popularity DESC")
  
  before_validation :set_permalink
  
  def publish!
    return true if published?
    update_attribute(:published, true)
  end
  
  def self.per_page; 9 end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def self.find_by_term(q)
    escaped_q = sanitize_sql(q)
    published.where("name like '%#{escaped_q}%' OR author like '%#{escaped_q}%' OR description like '%#{escaped_q}%'")
  end
  
  def pdf_name
    "#{to_param}.pdf"
  end
  
  def include_species?(species)
    entries.exists?(:element_type => species.class.to_s, :element_id => species.id.to_s) ||
    entries.exists?(:element_type => 'Kingdom', :element_id => species.kingdom) || 
    entries.exists?(:element_type => 'Phylum', :element_id => species.phylum) || 
    entries.exists?(:element_type => 'Class', :element_id => species.t_class) || 
    entries.exists?(:element_type => 'Order', :element_id => species.t_order) || 
    entries.exists?(:element_type => 'Family', :element_id => species.familiy) || 
    entries.exists?(:element_type => 'Genus', :element_id => species.genus)
  end
  
  def include_landscape?(landscape)
    entries.exists?(:element_type => landscape.class.to_s, :element_id => landscape.id.to_s)
  end
  
  def add_entry(element_type, element_id)
    case element_type
      when 'Species', 'Landscape', 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus'
        entries.create(:element_type => element_type, :element_id => element_id.to_s)
      when 'Guide'
        guide = Guide.find(element_id)
        guide.entries.each do |entry|
          entries.create(:element_type => entry.element_type, :element_id => entry.element_id)
        end
    end
  end
  
  private
  
    def set_permalink
      return if self.name.blank?
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
