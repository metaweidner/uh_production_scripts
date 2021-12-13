require 'yaml'
require 'yaml/store'
require 'pathname'

store = YAML::Store.new('tdd_metadata.yaml')
wdir = "P:/DigitalProjects/_TDD/3_to_ocr/1_to_statistics"
paths = Dir.glob("#{wdir}/**/metadata.txt")
paths.each do |path|
  files = []
  meta_path = Pathname.new(path)
  dir, file = meta_path.split
  file_paths = Dir["#{dir}/*.tif"]
  file_paths.each do |file|
    file_name = Pathname.new(file).basename.to_s
    files << file_name
  end
  metadata = YAML.load_file(path)
  metadata['Pages'] = files.size
  store.transaction do
    store[metadata['dc.identifier.other']] = {
      'metadata' => metadata,
      'files' => files
    }
    store.commit
  end
end
