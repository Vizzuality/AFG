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
#  last_action      :string(255)
#  pdf_file         :string(255)
#

class Guide < ActiveRecord::Base

  validates_presence_of :author, :if => Proc.new{ |guide| guide.published? }
  validates_presence_of :name, :if => Proc.new{ |guide| guide.published? }

  has_many :entries, :order => 'created_at ASC', :dependent => :destroy

  scope :published,       where("published = ?", true)
  scope :highlighted,     published.where("highlighted = ?", true)
  scope :not_highlighted, published.where("highlighted = ?", false)

  scope :sort_by_most_recent, order("created_at DESC")
  scope :sort_by_popularity,  order("downloads_count DESC")

  before_validation :set_permalink

  def publish!
    return true if published?
    update_attribute(:published, true)
  end

  def pages_count(mode = :complete)
    if mode == :complete
      species.size + landscapes.size + 3
    else
      (species.size.to_f / 4.0).ceil + (landscapes.size.to_f / 4.0).ceil + 3
    end
  rescue
    0
  end

  def size_in_bytes
    pages_count.to_f * 10000.to_f * 5.0
  end

  def self.per_page; 9 end

  def to_param
    "#{id}-#{permalink}"
  end

  def self.find_by_term(q)
    q = "%#{q}%"
    published.where(["name ilike ? OR author ilike ? OR description ilike ?", q, q, q]).order("downloads_count DESC")
  end

  def sort_by_attribute
    :downloads_count
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
    entries.exists?(:element_type => 'Family', :element_id => species.family) ||
    entries.exists?(:element_type => 'Genus', :element_id => species.genus)
  end

  def include_landscape?(landscape)
    entries.exists?(:element_type => landscape.class.to_s, :element_id => landscape.id.to_s)
  end

  def include_taxonomy?(taxonomy)
    entries.exists?(:element_type => taxonomy.hierarchy.humanize.to_s, :element_id => taxonomy.name)
  end

  def add_entry(element_type, element_id)
    guide_attributes = {:last_action, "#{element_type}##{element_id}"}
    entry = case element_type
      when 'Species', 'Landscape', 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus'
        entries.create(:element_type => element_type, :element_id => element_id.to_s)
      when 'Guide'
        guide_attributes[:parent_guide_id] = element_id
        guide = Guide.find(element_id)
        guide.entries.map do |entry|
          entries.create(:element_type => entry.element_type, :element_id => entry.element_id)
        end.compact
    end
    update_attributes(guide_attributes)
    entry
  end

  def default_picture(style)
    "/images/defaults/#{style}_specie.jpg"
  end

  def picture
    species_ids = species.map{ |s| s.id }
    Picture.find(:first, :conditions => "species_id IN (#{(species_ids + [-1]).join(',')})")
  end

  def picture?
    !picture.nil?
  end

  def undo_last_action
    return if last_action.blank?
    element_type, element_id = last_action.split('#')
    case element_type
      when 'Species', 'Landscape', 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus'
        entry = entries.find_by_element_type_and_element_id(element_type, element_id)
        entry.destroy
      when 'Guide'
        guide = Guide.find(element_id)
        guide.entries.each do |entry|
          entry = entries.find_by_element_type_and_element_id(entry.element_type, entry.element_id)
          entry.destroy
        end
    end
    update_attribute(:last_action, '')
  end

  def species
    entries.map do |entry|
      case entry.element_type
      when 'Landscape'
        nil
      when 'Species'
        entry.element
      else
        (entry && entry.element) ? entry.element.all_species : nil
      end
    end.compact.flatten.uniq
  end

  def species_kingdoms
    result = {}
    kingdoms = species.map{|s| s.kingdom}.uniq
    kingdoms.each do |k|
      result[k] = species.select{|s| s.kingdom == k}.size
    end
    result
  end

  def landscapes
    entries.find_all_by_element_type('Landscape').map do |e|
      e.element
    end
  end

  def generate_pdf!(request_fullpath, checklist = false)
    dir = "#{Rails.root}/public/pdfs"
    FileUtils.mkdir(dir) unless File.directory?(dir)
    filename = if self.published?
      "#{self.to_param}.pdf"
    else
      "#{self.id}-guide.pdf"
    end
    checklist = if checklist
      "?checklist=true"
    else
      nil
    end
    if !File.file?("#{dir}/#{filename}") || !self.published?
      url = URI.parse(request_fullpath)
      Net::HTTP.start(url.host, url.port) { |http|
        resp = http.get("/guides/pdf/#{self.to_param}.pdf#{checklist}")
        open("#{dir}/#{filename}", "wb") { |file|
          file.write(resp.body)
         }
      }
      if published?
        update_attribute(:pdf_file, "/pdfs/#{filename}")
      end
    else
      # We have to wait for the JS to be executed
      sleep 2
    end
    "/pdfs/#{filename}"
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
