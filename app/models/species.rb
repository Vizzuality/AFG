# == Schema Information
#
# Table name: species
#
#  id             :integer         not null, primary key
#  uid            :integer         
#  permalink      :string(255)     
#  name           :string(255)     
#  guides_count   :integer         default(0)
#  highlighted    :boolean         
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
#  kingdom        :string(255)     
#  phylum         :string(255)     
#  t_class        :string(255)     
#  t_order        :string(255)     
#  featured       :boolean         
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
  
  validates_presence_of :name
  
  before_validation :set_permalink
  
  scope :from_family, Proc.new{ |family| where(:family => family) }
  scope :highlighted, where(:highlighted => true)
  scope :featured, where(:featured => true)
  
  before_create :set_uid, :get_taxon

  def to_param
    "#{id}-#{permalink}"
  end
  
  def taxon
    return nil if self.kingdom.blank?
    "#{self.kingdom} > #{self.phylum} > #{self.t_class} > #{self.t_order} > #{self.family}"
  end
  
  def picture
    pictures.try(:first)
  end
  
  def default_picture
    "/images/default_big.png"
  end
  
  def self.families
    Species.select("family").map(&:family).uniq.sort
  end
  
  def full_name
    "#{self.genus} #{self.name}"
  end
  
  def self.find_by_term(q)
    escaped_q = sanitize_sql(q)
    where("name like '%#{escaped_q}%' OR genus like '%#{escaped_q}%' OR description like '%#{escaped_q}%'")
  end
  
  def self.get_taxon(uid)
    response = open("http://es.mirror.gbif.org/ws/rest/taxon/get?key="+uid.to_s).read
    doc = Nokogiri::XML(response)
    # If the uid doesn't exist
    return nil if doc.xpath("//tc:TaxonConcept").size == 0
    result = {}
    doc.xpath("//tc:TaxonConcept").each do |concept|
      # If is included in other species
      if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory").map{|r| r.attr('resource')}.include?("http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn")
        concept.xpath("tc:hasRelationship//tc:Relationship").each do |relationship|
          if relationship.xpath("tc:relationshipCategory")[0].attr('resource') == 'http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn'
            if included_uid = relationship.xpath("tc:toTaxon")[0].attr('resource').split('/').last
              return self.get_taxon(included_uid)
            end
          end
        end
      else
        # Get Taxon attributes
        if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory")[0].attr('resource') == "http://rs.tdwg.org/ontology/voc/TaxonConcept#IsChildTaxonOf"
          case concept.xpath("tc:hasName//tn:rankString")[0].inner_text
            when 'species'
              result[:name] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'genus'
              result[:genus] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
            when 'family'
              # nothing
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
      self.genus = atts[:genus]
      self.phylum = atts[:phylum]
    end
  end
  
  private
  
    def set_uid
      response = open("http://es.mirror.gbif.org/ws/rest/taxon/list?rank=species&scientificname="+URI.escape(self.full_name)).read
      doc = Nokogiri::XML(response)
      if doc.xpath("//tc:TaxonConcept").size > 0
        self.uid = doc.xpath("//tc:TaxonConcept")[0].attr('gbifKey').to_i
      end
    rescue
    end
  
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
