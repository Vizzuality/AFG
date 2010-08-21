# == Schema Information
#
# Table name: landscapes
#
#  id           :integer         not null, primary key
#  name         :string(255)     
#  permalink    :string(255)     
#  source       :string(255)     
#  description  :text            
#  related_url  :string(255)     
#  image1_url   :string(255)     
#  image2_url   :string(255)     
#  image3_url   :string(255)     
#  image4_url   :string(255)     
#  guides_count :integer         default(0)
#  created_at   :datetime        
#  updated_at   :datetime        
#  featured     :boolean         
#  the_geom     :geometry        
#

class Landscape < ActiveRecord::Base
  
  has_geom :the_geom => :multi_polygon
  
  before_validation :set_permalink
  
  has_many :pictures, :class_name => 'LandscapePicture'
  
  scope :featured,      where(:featured => true)
  scope :not_featured,  where(:featured => false)
  
  def self.find_by_term(q)
    q = "%#{q}%"
    where(["name like ? OR description like ?", q, q]).order("guides_count DESC")
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def sort_by_attribute
    :guides_count
  end
  
  def occurrences
    Occurrence.select("o.*").from("occurrences AS o, landscapes AS l").where("ST_Intersects(o.the_geom, l.the_geom) AND l.id=#{self.id}")
  end
  
  def species(options = {})
    conditions = ["ST_Intersects(occurrences.the_geom, landscapes.the_geom)", "landscapes.id=#{self.id}", "occurrences.species_id = species.id", "species.complete = true"]
    conditions += options[:conditions] if options[:conditions]
    limit = options[:limit] ? "LIMIT #{options[:limit]}" : nil
    offset = options[:offset] ? "OFFSET #{options[:offset]}" : nil
    Species.find_by_sql("select distinct(species.*) from species, occurrences, landscapes WHERE #{conditions.join(' AND ')} ORDER BY name DESC #{limit} #{offset}")
  end
  
  def species_count(options = {})
    conditions = ["ST_Intersects(occurrences.the_geom, landscapes.the_geom)", "landscapes.id=#{self.id}", "occurrences.species_id = species.id", "species.complete = true"]
    conditions += options[:conditions] if options[:conditions]
    Species.find_by_sql("select count(distinct(species.id)) AS count from species, occurrences, landscapes WHERE #{conditions.join(' AND ')}").first.count.to_i
  end
  
  def species_kingdoms
    result = {}
    kingdoms = species.map{|s| s.kingdom}.uniq
    kingdoms.each do |k|
      result[k] = species.select{|s| s.kingdom == k}.size
    end
    result
  end
  
  1.upto(4) do |i|
    define_method "image#{i}_url=".to_sym do |*args|
      value = args.first
      original_image_url = read_attribute("image#{i}_url".to_sym)
      write_attribute("image#{i}_url".to_sym, value)
      LandscapePicture.transaction do
        if picture = pictures.find_by_original_image_url(original_image_url)
          picture.destroy
        end
        picture = pictures.new :original_image_url => value
        picture.image = open(value)
        picture.save
      end
    end
  end
  
  def picture?
    !pictures.empty?
  end
  
  def picture
    pictures.empty? ? nil : pictures.first
  end
  
  def default_picture(style)
    "/images/defaults/#{style}_specie.jpg"
  end

  private
  
    def set_permalink
      return unless self.permalink.blank?
      self.permalink = name.sanitize unless name.blank?
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
