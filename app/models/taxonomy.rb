class Taxonomy
  
  def self.kingdoms
    Species.select("distinct(kingdom)").map(&:kingdom).delete_if{ |k| k.nil? || k == 'Unknown' }
  end
  
  def self.phylums(kingdom)
    Species.select("distinct(phylum)").where(:kingdom => kingdom).map(&:phylum).delete_if{ |k| k.nil? || k == 'Unknown' }
  end
  
  def self.t_classes(kingdom, phylum)
    Species.select("distinct(t_class)").where({:kingdom => kingdom, :phylum => phylum}).map(&:t_class).delete_if{ |k| k.nil? || k == 'Unknown' }
  end
  
  def self.t_orders(kingdom, phylum, t_class)
    Species.select("distinct(t_order)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class}).map(&:t_order).delete_if{ |k| k.nil? || k == 'Unknown' }
  end

  def self.families(kingdom, phylum, t_class, t_order)
    Species.select("distinct(family)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order}).map(&:family).delete_if{ |k| k.nil? || k == 'Unknown' }
  end

  def self.genus(kingdom, phylum, t_class, t_order, family)
    Species.select("distinct(genus)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family}).map(&:genus).delete_if{ |k| k.nil? || k == 'Unknown' }
  end

  def self.species(kingdom, phylum, t_class, t_order, family, genus)
    Species.select("distinct(name)").where({:kingdom => kingdom, :phylum => phylum, :t_class => t_class, :t_order => t_order, :family => family, :genus => genus}).map(&:name).delete_if{ |k| k.nil? || k == 'Unknown' }
  end
  
end