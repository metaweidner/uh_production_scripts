require './aspace.rb'
require 'httparty'
# require 'json'

aspace = ASpace.new('https://findingaids.lib.uh.edu:8089', 'weidnera', 'synergy7')
object = aspace.get_object('/repositories/2/archival_objects/34919')
resource = aspace.get_object(object['resource']['ref'])
parent = aspace.get_object(object['parent']['ref'])

# resource = aspace.get_object('/repositories/2/resources/15')
# parent = aspace.get_object('/repositories/2/archival_objects/32754')

# output = parent.to_json
# puts output

accession_number = resource['id_0']
box = parent['position']
type_2 = object['instances'][0]['sub_container']['type_2'].capitalize
type_3 = object['instances'][0]['sub_container']['type_3']
indicator_2 = object['instances'][0]['sub_container']['indicator_2']
indicator_3 = object['instances'][0]['sub_container']['indicator_3']
puts "#{accession_number}: Box #{box}, #{type_2} #{indicator_2}, #{type_3} #{indicator_3}"
