require 'json'
require 'fileutils'

def getLocation(type, indicator)
  if indicator.to_i > 0
    location = "%s_%03d/" % [type, indicator]
  else
    location = "%s_%s/" % [type, indicator]
  end
  location
end

carp_file_path = Dir.glob("#{Dir.pwd}/*.carp")[0]
carp_name = File.basename("#{carp_file_path}", ".carp")
file = File.read(carp_file_path)
carp = JSON.parse(file)
t = Time.now.strftime("%Y%m%d_%H%M")
FileUtils.mkdir_p "Documentation"
notes = File.new("Documentation/#{carp_name}_productionNotes_#{t}.txt", 'w')

carp['objects'].each do |object|
  note = object['productionNotes']
  unless note == ""
    title = object['metadata']['dcterms.title']
    container = object['containers'][0]
    location_1 = getLocation(container['type_1'], container['indicator_1'])
    if container['type_2'] == nil
      location_2 = ""
      location_3 = ""
    else
      location_2 = getLocation(container['type_2'], container['indicator_2'])
      if container['type_3'] == nil
        location_3 = ""
      else
        location_3 = getLocation(container['type_3'], container['indicator_3'])
      end
    end
    location = "Files/#{location_1}#{location_2}#{location_3}"
    notes.write("---------------------------------------------\n")
    notes.write("location: #{location}\ntitle: #{title}\nnote: #{note}\n\n")
  end
end

notes.close