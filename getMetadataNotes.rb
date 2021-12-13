require 'yaml'
require 'fileutils'

paths = Dir.glob("**/metadata.txt")
project_name = File.basename(Dir.pwd)
t = Time.now.strftime("%Y%m%d_%H%M")
FileUtils.mkdir_p "Documentation"
notes = File.new("Documentation/#{project_name}_metadataNotes_#{t}.txt", 'w')

paths.each do |path|
  metadata = YAML.load_file(path)
  unless metadata['note'] == nil
    title = metadata['title'].to_s
    location = metadata['location'].to_s
    note = metadata['note'].to_s
    notes.write("---------------------------------------------\n")
    notes.write("location: #{location}\ntitle: #{title}\nnote: #{note}\n\n")
  end
end

notes.close