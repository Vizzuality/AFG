# == Schema Information
#
# Table name: species
#
#  id                        :integer         not null, primary key
#  uid                       :integer         
#  permalink                 :string(255)     
#  name                      :string(255)     
#  guides_count              :integer         default(0)
#  highlighted               :boolean         
#  genus                     :string(255)     
#  family                    :string(255)     
#  common_name               :string(255)     
#  description               :text            
#  identification            :string(255)     
#  distribution              :text            
#  ecology                   :text            
#  size                      :text            
#  depth                     :text            
#  reference                 :text            
#  created_at                :datetime        
#  updated_at                :datetime        
#  kingdom                   :string(255)     
#  phylum                    :string(255)     
#  t_class                   :string(255)     
#  t_order                   :string(255)     
#  featured                  :boolean         
#  imported_file             :string(255)     
#  species                   :string(255)     
#  complete                  :boolean         
#  habitat                   :string(255)     
#  distinguishing_characters :text            
#  source_link               :string(255)     
#  source_name               :string(255)     
#

# Taxonomy sample:
#   Kingdom: Animalia
#   Phylum: Chordata
#   Class: Mammalia
#   Order: Carnivora
#   Family:Felidae
#   Genus: Puma
#   Species: Puma concolor


class Species < ActiveRecord::Base
    
  has_many :entries
  has_many :guides, :through => :entries
  has_many :pictures
  has_many :occurrences
  
  validates_presence_of :name
  
  validates_uniqueness_of :uid, :allow_nil => true, :allow_blank => true
  
  before_validation :set_permalink
  
  scope :highlighted,   where(:highlighted => true)
  scope :not_featured,  where(:featured => false)
  scope :featured,      where(:featured => true)
  scope :complete,      where(:complete => true)
  
  before_create :set_uid, :get_taxon, :set_complete 
  after_create :get_occurrences
  
  before_save :set_complete, :propagate_taxon

  def to_param
    "#{id}-#{permalink}"
  end
  
  def self.default_picture(style)
    "/images/defaults/#{style}_specie.jpg"
  end
  
  def default_picture(style)
    self.class.default_picture(style)
  end
  
  def taxon
    return nil if self.kingdom.blank?
    "#{self.kingdom} > #{self.phylum} > #{self.t_class} > #{self.t_order} > #{self.family} > #{self.genus}"
  end
  
  def picture
    pictures.try(:first)
  end
  
  def name
    species.blank? ? read_attribute(:name) : species
  end
  
  def full_name
    species.blank? ? "#{self.genus} #{name}" : species
  end
  
  def self.find_by_term(q)
    q = "%#{q}%"
    where(["species ilike ? OR name ilike ? OR genus ilike ? OR description ilike ?", q, q, q, q]).order("guides_count DESC")
  end
  
  def sort_by_attribute
    :guides_count
  end
  
  def self.get_taxon(uid)
    response = open("http://es.mirror.gbif.org/ws/rest/taxon/get?key="+uid.to_s).read
    doc = Nokogiri::XML(response)
    # If the uid doesn't exist
    return nil if doc.xpath("//tc:TaxonConcept").size == 0
    result = {}
    doc.xpath("//tc:TaxonConcept").each do |concept|
      next if concept.attr('status') != 'accepted'
      # If is included in other species
      if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory").map{|r| r.attr('resource')}.include?("http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn")
        concept.xpath("tc:hasRelationship//tc:Relationship").each do |relationship|
          if relationship.xpath("tc:relationshipCategory")[0].attr('resource') == 'http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn'
            if included_uid = relationship.xpath("tc:toTaxon")[0].attr('resource').split('/').last
              if included_uid != uid
                # debug
                # puts "get_taxon: #{uid} > #{included_uid}"
                return self.get_taxon(included_uid)
              end
            end
          end
        end
      else
      # Get Taxon attributes
        if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory")[0].attr('resource') == "http://rs.tdwg.org/ontology/voc/TaxonConcept#IsChildTaxonOf"
          case concept.xpath("tc:hasName//tn:rankString")[0].inner_text
            when 'species'
              result[:species] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'genus'
              result[:genus] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'family'
              result[:family] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'order'
              result[:t_order] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'class'
              result[:t_class] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'phylum'
              result[:phylum] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          end
        elsif concept.xpath("tc:hasName//tn:rankString")[0].inner_text == 'kingdom'
          result[:kingdom] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
        end
      end
    end
    # debug
    # if result.keys.size < 7
    #   puts "Resultado incompleto: #{uid}"
    # end
    result
  rescue
    {}
  end
  
  def get_taxon
    return if self.uid.blank?
    atts = self.class.get_taxon(self.uid)
    unless atts.empty?
      self.kingdom = atts[:kingdom]
      self.t_order = atts[:t_order]
      self.t_class = atts[:t_class]
      self.genus   = atts[:genus]
      self.phylum  = atts[:phylum]
      self.family  = atts[:family]
      self.species = atts[:species]
    end
    propagate_taxon
  end
  
  def self.get_uid(name)
    response = open("http://es.mirror.gbif.org/ws/rest/taxon/list?rank=species&scientificname="+URI.escape(name)).read
    doc = Nokogiri::XML(response)
    if doc.xpath("//gbif:dataProvider").size > 0
      doc.xpath("//gbif:dataProvider").each do |data_provider|
        if data_provider.attr('gbifKey').to_i == 1
          if data_provider.xpath("gbif:dataResources//tc:TaxonConcept").size > 0
            return data_provider.xpath("gbif:dataResources//tc:TaxonConcept")[0].attr('gbifKey').to_i
          end
        end
      end
    end
  rescue
    nil
  end
  
  def set_uid
    self.uid = self.class.get_uid(self.full_name)
  end
  
  def get_occurrences
    return if self.uid.blank?
    response = open("http://es.mirror.gbif.org/ws/rest/occurrence/list?taxonconceptkey=#{self.uid}&minlatitude=-90&maxlatitude=-65&minlongitude=-180&maxlongitude=180&georeferencedonly=true&coordinateissues=false").read
    doc = Nokogiri::XML(response)
    total_returned = doc.xpath("//gbif:summary")[0].attr('totalReturned').to_i
    (0...total_returned).each do |node|
      latitude = doc.xpath("//gbif:occurrenceRecords/to:TaxonOccurrence/to:decimalLatitude")[node].text.to_f            
      longitude = doc.xpath("//gbif:occurrenceRecords/to:TaxonOccurrence/to:decimalLongitude")[node].text.to_f
      date = if node_date = doc.xpath("//gbif:occurrenceRecords/to:TaxonOccurrence/to:latestDateCollected")[node]
        Date.parse(node_date.text)
      else
        nil
      end
      occurrences.create :date => date, :the_geom => Point.from_lon_lat(longitude, latitude)
    end
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
    
    def set_complete
      self.complete = (!self.uid.blank? && !self.kingdom.blank? && !self.t_order.blank? && !self.t_class.blank? && !self.genus.blank? && !self.phylum.blank? && !self.family.blank? && !self.species.blank?)
      return true
    end
    
    def propagate_taxon
      unless self.kingdom.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.kingdom, 'kingdom')
          Taxonomy.create! :name => self.kingdom, :hierarchy => 'kingdom'
        end
      end
      unless self.phylum.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.phylum, 'phylum')
          Taxonomy.create! :name => self.phylum, :hierarchy => 'phylum'
        end
      end
      unless self.t_class.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.t_class, 'class')
          Taxonomy.create! :name => self.t_class, :hierarchy => 'class'
        end
      end
      unless self.t_order.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.t_order, 'order')
          Taxonomy.create! :name => self.t_order, :hierarchy => 'order'
        end
      end
      unless self.family.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.family, 'family')
          Taxonomy.create! :name => self.family, :hierarchy => 'family'
        end
      end
      unless self.genus.blank?
        unless taxonomy = Taxonomy.find_by_name_and_hierarchy(self.genus, 'genus')
          Taxonomy.create! :name => self.genus, :hierarchy => 'genus'
        end
      end
    end
  
end
