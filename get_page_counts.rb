require 'pathname'
require 'fileutils'
require 'yaml'

paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/ocr-rework/**/*_metadata.txt")
paths.each do |path|
  metadata = Pathname.new(path)
  data = YAML.load_file(path)
  puts "#{metadata.basename.to_s}: #{data['Pages'].inspect}"
  # if data['Pages'] == ''
  #   meta_dir = metadata.parent
  #   volume = meta_dir.parent
  #   count = 0
  #   volume.children.each {|child| count += 1 if child.extname == '.tif'}
  #   puts "#{metadata.basename.to_s}: #{count}"
  #   data['Pages'] = count.to_s
  #   File.open(metadata, 'w') { |file| file.write(data.to_yaml) }
  # end
end
