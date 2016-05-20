# orchid collection
require 'csv'
require './orchid'
class OrchidCollection

	@@orchid_data = nil

	COLUMNS = [:id,	:major_group, :family, :genus_hybrid_marker, :genus, :species_hybrid_marker,
		:species, :infraspecific_rank, :infraspecific_epithet, :authorship, :taxonomic_status,
		:nomenclatural_status, :confidence_level, :source, :source_id, :IPNI_id, :publication,
		:collation, :page, :date]

	attr_accessor *COLUMNS	

	def initialize
		raise "Class cannot be instantiated"
	end

	def self.read_data(data_file)
		if @@orchid_data.nil?
			data = CSV.read(data_file)
			data.shift
			@@orchid_data = []

			data.each do |orc|
				an_orchid = Orchid.new
				Orchid.columns.each_with_index do |name, idx|
        			an_orchid.instance_variable_set("@" + name.to_s, orc[idx])
      			end
      		@@orchid_data << an_orchid
    	end
    end
    @@orchid_data
	end

	def self.species_per_genus(genus, all=true)
		# in this particular dataset there is a one-one correspondence
		# between genus and species so line below is valid

		some_orchids = @@orchid_data.select{|o| o.genus == genus}
		raise "Genus not known!" if some_orchids.count == 0
		if all
			number_of_species = some_orchids.count
		else
			number_of_species = some_orchids.reject{|o| o.taxonomic_status != "Accepted"}.count
		end
		 
		number_of_species
	end

	def self.year_classified(genus)
		some_orchids = @@orchid_data.select{|o| o.genus == genus}
		first_year = some_orchids.map(&:date).min
		latest_year = some_orchids.map(&:date).max
		puts genus + " orchids were first classified in " + first_year
		puts "The latest species of this genus to be classified was in "+ latest_year

	end

	def self.write_csv(data)
		puts "Please enter the name of the file to write"
		puts "This will write the Orchid data out"

		file = gets.chomp
		while file == ""
  		file = gets.chomp
		end
		if File.exist?(file)
  		raise "This file already exists"
		end
		CSV.open(file,"w") do |csv|
			#writing header row
			csv << COLUMNS.map(&:to_s)
			data.each do |orc|
				csv << COLUMNS.map do |col|
					orc.send(col)
				end
			end
		end
	end
end
