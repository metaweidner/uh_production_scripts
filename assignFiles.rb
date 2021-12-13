require 'json'

def start_wizard(wdir)
  puts "Assign CARP Files"
  puts "> Enter the project folder name"
  project = $stdin.gets.chomp
  puts "\nYou entered: #{project}"
  puts "Assign files for this project? (Yes[y]/No[n])\n"
  puts "> "
  response = $stdin.gets.chomp
  case response
  when 'Y', 'y', 'Yes', 'yes'
    carp_file_path = Dir.glob("#{wdir}/#{project}/*.carp")[0]
    puts "Processing #{project}..."
    puts carp_file_path
    file = File.read(carp_file_path)
    carp = JSON.parse(file)

    carp['objects'].each do |object|
      associated_files = []
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
      object_path = "#{wdir}/#{project}/Files/#{location_1}#{location_2}#{location_3}"
      carp_path = "Files/#{location_1}#{location_2}#{location_3}"
      files = Dir.glob("#{object_path}*")
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
        associated_files << {"path" => "#{carp_path}#{file_name}".gsub('/', '\\\\'), "purpose" => purpose}
      end
      object['files'] = associated_files
    end
    t = Time.now.strftime("%Y%m%d")
    carp_file_name = carp_file_path.split("/")[-1]
    File.write("#{wdir}/#{project}/#{t}_#{carp_file_name}", carp.to_json)

  when 'N', 'n', 'No', 'no'
    puts "File Assignment Cancelled"
    exit
  end
end

def getLocation(type, indicator)
  if indicator.to_i > 0
    location = "%s_%03d/" % [type, indicator]
  else
    location = "%s_%s/" % [type, indicator]
  end
  location
end

begin
  start_wizard(Dir.pwd)
rescue Exception => e
  File.open("#{Dir.pwd}/exceptions.log", "w") do |f|
    f.puts e.inspect
    f.puts e.backtrace
  end
end
