require 'pathname'
require 'fileutils'
require 'yaml'

paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/ocr-rework/**/metadata.txt")
paths.each do |path|
  metadata = Pathname.new(path)
  data = YAML.load_file(path)
  puts "#{metadata.basename.to_s}: #{data['Pages'].inspect}"
  meta_dir = metadata.parent
  volume = meta_dir.parent.basename.to_s
  puts "#{meta_dir}/#{volume}_metadata.txt"
  metadata.rename("#{meta_dir}/#{volume}_metadata.txt")
end
