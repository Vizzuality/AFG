class ChangeSpeciesFieldsFromStringToText < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE species ALTER identification TYPE text")
    execute("ALTER TABLE species ALTER habitat TYPE text")
  end

  def self.down
    execute("ALTER TABLE species ALTER identification TYPE character varying(255)")
    execute("ALTER TABLE species ALTER habitat TYPE character varying(255)")
  end
end
