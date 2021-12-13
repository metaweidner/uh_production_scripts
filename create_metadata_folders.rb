require 'pathname'
require 'fileutils'

paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/20200110/**/metadata.txt")
# paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/ocr-rework/**/metadata.txt")

# paths.each do |path|
#   metadata = Pathname.new(path)
#   volume = metadata.parent
#   meta_dir = volume.join('metadata')
#   FileUtils.mkdir_p meta_dir
#   FileUtils.mv metadata, meta_dir.join('metadata.txt')
# end

paths.each do |path|
  metadata = Pathname.new(path)
  volume = metadata.parent.basename.to_s
  batch = metadata.parent.parent
  meta_dir = batch.join('Output', 'TIFF', batch.basename.to_s, volume, 'metadata')
  FileUtils.mkdir_p meta_dir
  FileUtils.cp metadata, meta_dir.join('metadata.txt')
  puts 'Copied: ' + meta_dir.join('metadata.txt').to_s
end
