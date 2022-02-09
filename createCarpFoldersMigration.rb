require 'json'

# cdm_collection_url = 'https://digital.lib.uh.edu/collection/p15195coll10/item/' # marine bombing
cdm_collection_url = 'https://digital.lib.uh.edu/collection/2010_013/item/' # ypinia
aspace_url = 'https://findingaids.lib.uh.edu'

# file = File.read('p15195coll10_20190620_0732.carp') # marine bombing
file = File.read('.carp') # ypinia
carp_data = JSON.parse(file)
# objectNotes = File.new('objectNotes.txt', 'w')

carp_data['objects'].each do |object|
  location_1 = object['containers'][0]['type_1'] + "_" + object['containers'][0]['indicator_1']
  location_2 = object['containers'][0]['type_2'] + "_" + object['containers'][0]['indicator_2']
  location_3 = object['containers'][0]['type_3'] + "_" + object['containers'][0]['indicator_3']
  folder = "#{location_1}/#{location_2}/#{location_3}"
  FileUtils.mkdir_p "Files/#{folder}"
  metadata = File.new("Files/#{folder}/metadata.txt")
  metadata.write("ASpace URL: " + aspace_url + object['uri'] + "\n")
  pointer = object['productionNotes'][5..-1]
  metadata.write("CDM URL: " + cdm_collection_url + pointer + "\n")
  metadata.write("CDM Title: " + object['metadata']['dcterms.title'] + "\n")
  metadata.write("CDM Location: " + object['metadata']['dcterms.identifier'] + "\n")
  metadata.write("title: " + object['title'] + "\n")
  metadata.write("location: " + folder + "\n")
  metadata.write("notes:\n\n")
  metdata.close
end




# objectNotes.close

# puts "ASpace Title: " + carp_data['objects'][0]['title']
# puts "ASpace URI: " + carp_data['objects'][0]['uri']
# location_1 = carp_data['objects'][0]['containers'][0]['type_1'] + "_" + carp_data['objects'][0]['containers'][0]['indicator_1']
# location_2 = carp_data['objects'][0]['containers'][0]['type_2'] + "_" + carp_data['objects'][0]['containers'][0]['indicator_2']
# location_3 = carp_data['objects'][0]['containers'][0]['type_3'] + "_" + carp_data['objects'][0]['containers'][0]['indicator_3']
# puts "ASpace Location: " + "#{location_1}/#{location_2}/#{location_3}"
# puts "CDM Title: " + carp_data['objects'][0]['metadata']['dcterms.title']
# pointer = carp_data['objects'][0]['productionNotes'][5..-1]
# puts "CDM URL: " + cdm_collection_url + pointer
# puts "CDM Location: " + carp_data['objects'][0]['metadata']['dcterms.identifier']
