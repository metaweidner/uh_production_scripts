require 'pathname'
require 'fileutils'

paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/ocr-rework/**/metadata.txt")
paths.each do |path|
  metadata = Pathname.new(path)
  meta_dir_2 = metadata.parent
  meta_dir = meta_dir_2.parent
  FileUtils.mv metadata, meta_dir.join('metadata.txt')
  meta_dir_2.delete
end
