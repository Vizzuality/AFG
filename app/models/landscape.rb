# == Schema Information
#
# Table name: landscapes
#
#  id           :integer         not null, primary key
#  name         :string(255)     
#  permalink    :string(255)     
#  description  :text            
#  related_url  :string(255)     
#  image1_url   :string(255)     
#  image2_url   :string(255)     
#  image3_url   :string(255)     
#  image4_url   :string(255)     
#  guides_count :integer         default(0)
#  radius       :integer         default(50000)
#  featured     :boolean         
#  created_at   :datetime        
#  updated_at   :datetime        
#  the_geom     :geometry        not null
#  source_link  :string(255)     
#  source_name  :string(255)     
#

class Landscape < ActiveRecord::Base
  
  has_geom :the_geom => :point
  
  before_validation :set_permalink, :set_the_geom
  
  before_save :expire_cache
  
  attr_accessor :latitude, :longitude
  
  has_many :pictures, :class_name => 'LandscapePicture'
  
  scope :featured,      where(:featured => true)
  scope :not_featured,  where(:featured => false)
  
  def self.find_by_term(q)
    q = "%#{q}%"
    where(["name ilike ? OR description ilike ?", q, q]).order("guides_count DESC")
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def sort_by_attribute
    :guides_count
  end
  
  def occurrences
    Occurrence.select("o.*").from("occurrences AS o, landscapes AS l").where("st_dwithin(o.the_geom::geography,l.the_geom::geography, l.radius) AND l.id=#{self.id}")
  end
  
  def species(options = {})
    conditions = ["st_dwithin(occurrences.the_geom::geography,landscapes.the_geom::geography, landscapes.radius)", "landscapes.id=#{self.id}", "occurrences.species_id = species.id", "species.complete = true"]
    conditions += options[:conditions] if options[:conditions]
    limit = options[:limit] ? "LIMIT #{options[:limit]}" : nil
    offset = options[:offset] ? "OFFSET #{options[:offset]}" : nil
    Species.find_by_sql("select distinct(species.*) from species, occurrences, landscapes WHERE #{conditions.join(' AND ')} ORDER BY name DESC #{limit} #{offset}")
  end
  
  def species_count(options = {})
    conditions = ["st_dwithin(occurrences.the_geom::geography,landscapes.the_geom::geography, landscapes.radius)", "landscapes.id=#{self.id}", "occurrences.species_id = species.id", "species.complete = true"]
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
      return if value.blank?
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
  
  def to_json
    {
      :name => self.name,
      :description => self.description,
      :guides_count => self.guides_count,
      :picture => self.picture? ? self.picture.image.url(:small) : nil,
      :lat => self.the_geom.lat,
      :lon => self.the_geom.lon
    }
  end
  
  def self.maps_cache_path(key)
    dir = "#{Rails.root}/public/cache/#{key.split('/').first}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    "#{dir}/#{key.split('/').last}"
  end
  
  def self.maps_cache_get(id)
    key = "landscapes/#{id}"
    if File.file?(maps_cache_path(key))
      File.read(maps_cache_path(key))
    else
      nil
    end
  end
  
  def self.maps_cache_set(id, value)
    key = "landscapes/#{id}"
    File.open(maps_cache_path(key), "w").write(value)
  end
  
  def self.maps_cache_delete(id)
    key = "landscapes/#{id}"
    if File.file?(maps_cache_path(key))
      FileUtils.rm(maps_cache_path(key))
    end
  end

  private
  
    def expire_cache
      if radius_changed? && !self.new_record?
        self.class.maps_cache_delete(self.id)
      end
    end
  
    def set_the_geom
      return if new_record? || self.longitude.nil? || self.latitude.nil?
      self.the_geom = Point.from_lon_lat(self.longitude, self.latitude)
      self.class.maps_cache_delete(self.id) unless self.new_record?
    end
  
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
