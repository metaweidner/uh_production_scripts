require 'fileutils'
require 'pathname'

def start_wizard(wdir)
  dir = Pathname.new(wdir)
  children = []
  dir.children.each do |child|
    case child.basename.to_s
    when 'createSeparationFolders.exe'
      next
    when '1_to_separation'
      next
    when 'exceptions.log'
      next
    else
      children << child
    end
  end
  children.each do |child|
    processBatch(child)
    FileUtils.mv(child, child.parent.join("1_to_separation/#{child.basename.to_s}"))
  end
  puts "\nSeparation directories have been created.\nPress any key to exit the application."
  response = $stdin.gets.chomp
end

def processBatch(digi_batch)
  digi_batch.children.each do |volume|
    if volume.basename.to_s == 'Output'
      next
    else
      oclc = volume.basename.to_s
      FileUtils.mkdir_p "#{digi_batch}/Output/TIFF/#{digi_batch.basename.to_s}/#{oclc}/metadata"
      FileUtils.cp("#{volume}/metadata.txt", "#{digi_batch}/Output/TIFF/#{digi_batch.basename.to_s}/#{oclc}/metadata/metadata.txt")
    end
  end
end

#   if File.file? "#{wdir}/#{batch}.txt"
#     total_found = 0
#     found = []
#     objects = []
#     File.readlines("#{wdir}/#{batch}.txt").each {|line| objects << line.strip.to_s}
#     total_prepared = objects.size
#     FileUtils.mkdir_p "#{wdir}/#{batch}"

#     puts "Create Digi Batch (Pre-1978)"
#     puts "Loading master data from 1_tdd-pre-1978 ..."
#     paths = Dir.glob("#{wdir}/1_tdd-pre-1978/**/**")
#     paths.each do |path|
#       dir = Pathname.new(path)
#       if objects.include? dir.basename.to_s
#         dir_name = dir.basename.to_s
#         FileUtils.mv path, "#{wdir}/#{batch}/#{dir_name}"
#         found << dir_name
#         objects.delete(dir_name)
#       end
#     end
#     if total_prepared == found.size
#       puts "Successfully created batch #{batch} with #{total_prepared} objects: #{found}"
#       puts "Press Enter to exit the application."
#       $stdin.gets.chomp
#     else
#       puts "Created batch #{batch} with #{found.size} objects: #{found}"
#       puts "Could not find #{objects.size} of #{total_prepared} objects: #{objects}"
#       puts "Press Enter to exit the application."
#       $stdin.gets.chomp
#     end
#   else
#     puts "Batch file \'#{batch}.txt\' does not exist. Try again? [Y/N]"
#     response = $stdin.gets.chomp
#     case response
#     when 'Y', 'y', 'Yes', 'yes'
#       start_wizard(wdir)
#     when 'N', 'n', 'No', 'no'
#       exit
#     else
#       puts "Unrecognized input. Exiting application."
#       exit
#     end
#   end
# end

begin
  start_wizard(Dir.pwd)
rescue Exception => e
  File.open("#{Dir.pwd}/exceptions.log", "w") do |f|
    f.puts e.inspect
    f.puts e.backtrace
  end
end
