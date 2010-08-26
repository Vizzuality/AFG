# == Schema Information
#
# Table name: taxonomies
#
#  id                        :integer         not null, primary key
#  name                      :string(255)     
#  hierarchy                 :string(255)     
#  downloads_count           :integer         default(0)
#  description               :text            
#  distinguishing_characters :text            
#

class Taxonomy < ActiveRecord::Base
  
  validates_uniqueness_of :name, :scope => :hierarchy
  
  def self.find_by_term(q)
    q = "%#{q}%"
    where(["name ilike ? OR hierarchy ilike ?", q, q]).order("name DESC")
  end
  
  def species(limit = 1)
    column = if self.hierarchy == 'class'
      :t_class
    elsif self.hierarchy == 'order'
      :t_order
    else 
      self.hierarchy.to_sym
    end
    Species.complete.where(column => self.name).limit(limit).first
  end
  
  def all_species
    column = if self.hierarchy == 'class'
      :t_class
    elsif self.hierarchy == 'order'
      :t_order
    else 
      self.hierarchy.to_sym
    end
    Species.complete.where(column => self.name)
  end
  
  def species_count
    column = if self.hierarchy == 'class'
      :t_class
    elsif self.hierarchy == 'order'
      :t_order
    else 
      self.hierarchy.to_sym
    end
    Species.complete.where(column => self.name).count    
  end
  
  def self.kingdoms
    Species.select("distinct(kingdom)").map{ |x| x.kingdom}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |k|
      Taxonomy.find_by_name_and_hierarchy(k, 'kingdom')
    end
  end
  
  def self.phylums(kingdom)
    Species.select("distinct(phylum)").where(:kingdom => kingdom).map{|x| x.phylum}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |p|
      Taxonomy.find_by_name_and_hierarchy(p, 'phylum')
    end
  end
  
  def self.t_classes(phylum)
    Species.select("distinct(t_class)").where({:phylum => phylum}).map{|x| x.t_class}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |tc|
      Taxonomy.find_by_name_and_hierarchy(tc, 'class')
    end
  end
  
  def self.t_orders(t_class)
    Species.select("distinct(t_order)").where({:t_class => t_class}).map{|x| x.t_order}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |to|
      Taxonomy.find_by_name_and_hierarchy(to, 'order')
    end
  end

  def self.families(t_order)
    Species.select("distinct(family)").where({:t_order => t_order}).map{|x| x.family}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |f|
      Taxonomy.find_by_name_and_hierarchy(f, 'family')
    end
  end

  def self.genus(family)
    Species.select("distinct(genus)").where({:family => family}).map{|x| x.genus}.delete_if{ |k| k.nil? || k == 'Unknown' }.map do |g|
      Taxonomy.find_by_name_and_hierarchy(g, 'genus')
    end
  end
  
end
