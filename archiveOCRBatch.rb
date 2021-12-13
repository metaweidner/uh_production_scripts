require 'fileutils'
require 'pathname'
require 'facets'
require 'yaml'
require 'yaml/store'
require 'ruby-progressbar'

def archive_batch(ac_archive, ocr_input, ocr_output, to_metadata)
  batch = Time.now.strftime("%Y%m%d")
  input_paths = Dir.glob("#{ocr_input}/**")
  output_paths = Dir.glob("#{ocr_output}/**")
  if input_paths.size == output_paths.size
    input_dirs = []
    output_dirs = []
    input_paths.each {|path| input_dirs << Pathname.new(path).basename.to_s}
    output_paths.each {|path| output_dirs << Pathname.new(path).basename.to_s}
    if input_dirs.frequency == output_dirs.frequency
      total = input_paths.size + output_paths.size
      progressbar = ProgressBar.create(total: total, format: "Archiving #{batch}: %c/%C |%W|")
      FileUtils.mkdir_p "#{ac_archive}/#{batch}"
      FileUtils.mkdir_p "#{to_metadata}/#{batch}"
      input_metadata = {}
      output_metadata = {}
      input_paths.each do |path|
        input_files = []
        id = Pathname.new(path).basename.to_s
        input_file_paths = Dir["#{path}/*"]
        input_file_paths.each {|file| input_files << Pathname.new(file).basename.to_s}
        input_metadata[id] = input_files
        FileUtils.mv path, "#{ac_archive}/#{batch}/#{id}"
        progressbar.increment
      end
      output_paths.each do |path|
        output_files = []
        id = Pathname.new(path).basename.to_s
        output_file_paths = Dir["#{path}/*"]
        output_file_paths.each {|file| output_files << Pathname.new(file).basename.to_s}
        output_metadata[id] = output_files
        FileUtils.mv path, "#{to_metadata}/#{batch}/#{id}"
        progressbar.increment
      end
      store = YAML::Store.new('tdd_ocr.yaml')
      store.transaction do
        store[batch] = {
          'ac_archive' => input_metadata,
          'to_metadata' => output_metadata
        }
        store.commit
      end
    else
      puts "The identifiers in the Input & Ouput directories do not match."
      puts "Please check the directories and try again."
      exit
    end
  else
    puts "Number of volumes in Input & Output directories do not match."
    puts "Please check the directories and try again."
    exit
  end
  progressbar.finish
  puts "Batch Archiving Complete"
end

begin
  ac_archive = "P:/DigitalProjects/_TDD/3_to_ocr/0_AC_TIFF_Archive"
  ocr_input = "P:/DigitalProjects/_TDD/3_to_ocr/2_input"
  ocr_output = "P:/DigitalProjects/_TDD/3_to_ocr/3_output"
  to_metadata = "P:/DigitalProjects/_TDD/4_to_metadata"
  to_archive = "P:/DigitalProjects/_TDD/3_to_ocr/4_to_archive"
  archive_batch(ac_archive, ocr_input, ocr_output, to_metadata)
rescue Exception => e
  File.open("#{to_archive}/archiveOCRBatch.log", "a") do |f|
    f.puts Time.now
    f.puts e.inspect
    f.puts e.backtrace
    f.puts "\n"
  end
end
