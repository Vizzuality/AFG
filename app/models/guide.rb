# == Schema Information
#
# Table name: guides
#
#  id              :integer         not null, primary key
#  permalink       :string(255)     
#  name            :string(255)     
#  author          :string(255)     
#  description     :text            
#  species_count   :integer         default(0)
#  downloads_count :integer         default(0)
#  session_id      :string(255)     
#  popularity      :integer         default(0)
#  highlighted     :boolean         
#  published       :boolean         
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Guide < ActiveRecord::Base
  
  has_permalink :name
  
  validates_presence_of :author, :if => Proc.new{ |guide| guide.published? }
  validates_presence_of :name, :if => Proc.new{ |guide| guide.published? }

  has_many :entries, :order => 'created_at DESC'
  has_many :species, :through => :entries
  has_many :included_guides, :through => :entries, :source => :included_guide
  
  scope :published,       where("published = ?", true)
  scope :highlighted,     published.where("highlighted = ?", true)
  scope :not_highlighted, published.where("highlighted = ?", false)
  
  scope :sort_by_most_recent, order("created_at DESC")
  scope :sort_by_popularity,  order("popularity DESC")
  
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
  
end
