class Taxonomy
  
  def self.kingdoms
    kingdoms = Species.select("distinct(kingdom)").map{ |x| x.kingdom}.delete_if{ |k| k.nil? || k == 'Unknown' }
    kingdoms.map do |k|
      [k, Species.count(:conditions => {:kingdom => k})]
    end
  end
  
  def self.phylums(kingdom)
    phylums = Species.select("distinct(phylum)").where(:kingdom => kingdom).map{|x| x.phylum}.delete_if{ |k| k.nil? || k == 'Unknown' }
    phylums.map do |p|
      [p, Species.count(:conditions => {:kingdom => kingdom, :phylum => p})]
    end
  end
  
  def self.t_classes(kingdom, phylum)
    t_classes = Species.select("distinct(t_class)").where({:kingdom => kingdom, :phylum => phylum}).map{|x| x.t_class}.delete_if{ |k| k.nil? || k == 'Unknown' }
    t_classes.map do |tc|
      [tc, Species.count(:conditions => {:kingdom => kingdom, :phylum => phylum, :t_class => tc})]
    end
  end
  
  def self.t_orders(kingdom, phylum, t_class)
    t_orders = Species.select("distinct(t_order)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class}).map{|x| x.to_order}.delete_if{ |k| k.nil? || k == 'Unknown' }
    t_orders.map do |to|
      [to, Species.count(:conditions => {:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => to})]
    end
  end

  def self.families(kingdom, phylum, t_class, t_order)
    families = Species.select("distinct(family)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order}).map{|x| x.family}.delete_if{ |k| k.nil? || k == 'Unknown' }
    families.map do |f|
      [f, Species.count(:conditions => {:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => f})]
    end
  end

  def self.genus(kingdom, phylum, t_class, t_order, family)
    genus = Species.select("distinct(genus)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family}).map{|x| x.genus}.delete_if{ |k| k.nil? || k == 'Unknown' }
    genus.map do |g|
      [g, Species.count(:conditions => {:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family, :genus => g})]
    end
  end

  def self.species(kingdom, phylum, t_class, t_order, family, genus)
    species = Species.select("distinct(name)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family, :genus => genus}).map{|x| x.name}.delete_if{ |k| k.nil? || k == 'Unknown' }
    species.map do |s|
      [s, Species.count(:conditions => {:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family, :genus => genus, :name => s})]
    end
  end
  
end