require 'json'

file = File.read('./2016_036_exhibit_catalogs_AJW.carp')
carp = JSON.parse(file)

carp['objects'].each do |object|
  associated_files = []
  container = object['containers'][0]
  location_1 = "%s_%03d/" % [container['type_1'], container['indicator_1']]
  if container['type_2'] == nil
    location_2 = ""
  else
    location_2 = "%s_%03d/" % [container['type_2'], container['indicator_2']]
  end
  if container['type_3'] == nil
    location_3 = ""
  else
    location_3 = "%s_%03d/" % [container['type_3'], container['indicator_3']]
  end
  folder_path = "Files/#{location_1}#{location_2}#{location_3}"
  files = Dir.glob("#{folder_path}*")
  files.each do |file|
    file_name = file.split("/")[-1]
    if file_name.include? "_ac"
      purpose = "access-copy"
    elsif file_name.include? "_pm"
      purpose = "preservation"
    else
      purpose = "sub-documents"
    end
    associated_files << { "path" => file.gsub('/', '\\\\'), "purpose" => purpose}
  end
  object['files'] = associated_files
end
carp_file = File.write('./2016_03_exhibit_catalogs_AJW_assigned.carp', carp.to_json)