require 'yaml'
require 'pathname'
require 'fileutils'

paths = Dir.glob("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/**/metadata.txt")

paths.each do |path|
  begin
    metadata = YAML.load_file(path)
  rescue
    File.open("P:/DigitalProjects/_TDD/3_to_ocr/0_staging/validation_errors.txt", "a") do |f|
      f.write "#{path}\n"
    end
  end
end
