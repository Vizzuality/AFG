# == Schema Information
#
# Table name: landscapes
#
#  id                 :integer         not null, primary key
#  name               :string(255)     
#  permalink          :string(255)     
#  description        :text            
#  related_url        :string(255)     
#  image1_url         :string(255)     
#  image2_url         :string(255)     
#  image3_url         :string(255)     
#  image4_url         :string(255)     
#  guides_count       :integer         default(0)
#  radius             :integer         default(50000)
#  featured           :boolean         
#  created_at         :datetime        
#  updated_at         :datetime        
#  source_link        :string(255)     
#  source_name        :string(255)     
#  the_geom           :geometry        not null
#  image1_description :text            
#  image2_description :text            
#  image3_description :text            
#  image4_description :text            
#

class Landscape < ActiveRecord::Base
  
  has_geom :the_geom => :point
  
  before_validation :set_permalink, :set_the_geom
  
  before_save :expire_cache
  after_destroy :remove_entries
  
  attr_accessor :latitude, :longitude, :images_descriptions
  
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
  
  def description_for_picture(original_image_url)
    case original_image_url
    when image1_url
      image1_description
    when image2_url
      image2_description
    when image3_url
      image3_description
    when image4_url
      image4_description
    end
  end
  
  1.upto(4) do |i|
    define_method "image#{i}_url=".to_sym do |*args|
      value = args.first
      return if new_record? || !send("image#{i}_url_changed?")
      original_image_url = read_attribute("image#{i}_url".to_sym)
      write_attribute("image#{i}_url".to_sym, value)
      if value.blank?
        if picture = pictures.find_by_original_image_url(original_image_url)
          picture.destroy
        end
        return
      end
      LandscapePicture.transaction do
        begin
          if picture = pictures.find_by_original_image_url(original_image_url)
            picture.destroy
          end
          picture = pictures.new :original_image_url => value
          picture.image = open(value)
          picture.save
        rescue
        end
      end
    end
  end
  
  def picture?
    !pictures.empty?
  end
  
  def picture
    pictures.try(:last)
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
      return if self.longitude.nil? || self.latitude.nil?
      self.the_geom = Point.from_lon_lat(self.longitude, self.latitude)
      return if new_record?
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
    
    def remove_entries
      Entry.where(:element_type => self.class.name, :element_id => self.id.to_s).all.each{ |e| e.destroy }
    end
        
end
