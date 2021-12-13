require 'json'

def getLocation(type, indicator)
  if indicator.to_i > 0
    location = "%s_%03d/" % [type, indicator]
  else
    location = "%s_%s/" % [type, indicator]
  end
  location
end

CARP_FILE = ARGV[0]
file = File.read(CARP_FILE)
carp = JSON.parse(file)

carp['objects'].each do |object|
  associated_files = []
  container = object['containers'][0]
  location_1 = getLocation(container['type_1'], container['indicator_1'])
  if container['type_2'] == nil
    location_2 = ""
  else
    location_2 = getLocation(container['type_2'], container['indicator_2'])  end
  if container['type_3'] == nil
    location_3 = ""
  else
    location_3 = getLocation(container['type_3'], container['indicator_3'])  end
  folder_path = "Files/#{location_1}#{location_2}#{location_3}"
  files = Dir.glob("#{folder_path}*")
  files.each do |file|
    file_name = file.split("/")[-1]
    if file_name.include? "_ac.tif"
      purpose = "access-copy"
    elsif file_name.include? "_pm.tif"
      purpose = "preservation"
    elsif file_name.include? "_mm.tif"
      purpose = "modified-master"
    else
      purpose = "sub-documents"
    end
    associated_files << { "path" => file.gsub('/', '\\\\'), "purpose" => purpose}
  end
  object['files'] = associated_files
end
t = Time.now.strftime("%Y%m%d")
File.write("#{t}_#{CARP_FILE}", carp.to_json)
