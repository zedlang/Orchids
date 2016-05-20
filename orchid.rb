# Orchid class

class Orchid

  include Comparable

  def <=>(other)
    self.genus <=> other.genus
  end

  # As read in from a CSV file
  def self.columns
    [:id, :major_group, :family, :genus_hybrid_marker, :genus, :species_hybrid_marker,
    :species, :infraspecific_rank, :infraspecific_epithet, :authorship, :taxonomic_status,
    :nomenclatural_status, :confidence_level, :source, :source_id, :IPNI_id, :publication,
    :collation, :page, :date]
  end
  
  attr_accessor *self.columns 

  

end