require 'fileutils'
require 'pathname'
require 'yaml'
require 'ruby-progressbar'

def archive_batch(batch_name, pm_archive)
  batch = Pathname.new(batch_name)
  paths = Dir.glob("#{batch}/**/metadata.txt")
  progressbar = ProgressBar.create(total: paths.size, format: "Archiving #{batch_name}: %c/%C |%W|")
  date_digitized = Time.now.strftime("%Y%m%d")
  paths.each do |path|
    progressbar.increment
    metadata = Pathname.new(path)
    dir, file = metadata.split
    parent, object = dir.split
    pages = Dir.glob("#{batch}/#{object}/*.tif").length
    data = YAML.load_file(path)
    data['PagesPM'] = pages
    data['DateDigitized'] = date_digitized
    data['DigiBatch'] = batch_name
    ac_path = "#{batch}/Output/TIFF/" + object.to_s
    File.open("#{ac_path}/metadata.txt", "w") {|file| file.write(data.to_yaml)}
    dest_path = "P:/DigitalProjects/_TDD/3_to_ocr/#{object.to_s}"
    FileUtils.mv ac_path, dest_path
  end
  FileUtils.remove_dir "#{batch}/Output"
  FileUtils.mv batch, "#{pm_archive}/#{batch.basename}"
  File.open("#{pm_archive}/archiveDigitizedBatch.log", "a") do |f|
    f.puts Time.now
    f.puts "Batch: #{batch}"
    f.puts "Successfully archived batch directory."
    f.puts "#{pm_archive}/#{batch.basename}"
    f.puts "\n"
  end
  progressbar.finish
  puts "Batch Archiving Complete"
end

begin
  pm_archive = "P:/DigitalProjects/_TDD/2_to_digitization/3_to_archive/0_PM_TIFF_Archive"
  archive_batch(ARGV[0], pm_archive)
rescue Exception => e
  File.open("#{pm_archive}/archiveDigitizedBatch.log", "a") do |f|
    f.puts Time.now
    f.puts "Batch: #{ARGV[0]}"
    f.puts e.inspect
    f.puts e.backtrace
    f.puts "\n"
  end
end
