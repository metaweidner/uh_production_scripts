require 'pathname'

# get all files/directories recursively
# paths = Dir.glob("Production/Files/**/*")
ac_paths = Dir.glob("Production/Files/**/ac")
pm_paths = Dir.glob("Production/Files/**/pm")

# get current working directory
# wdir = Dir.pwd
ac = []
ac_paths.each do |path|
  ac_files = Dir.glob("#{path}/*")
  if ac_files == []
    ac << "#{path}: Delete Directory"
  else
    sub_ac = []
    sub_ac << path
    ac_files.each {|file| sub_ac << File.basename(file)}
    ac << sub_ac
  end
end

pm = []
pm_paths.each do |path|
  pm_files = Dir.glob("#{path}/*")
  if pm_files == []
    pm << "#{path}: Delete Directory"
  else
    sub_pm = []
    sub_pm << path
    pm_files.each {|file| sub_pm << File.basename(file)}
    pm << sub_pm
  end
end

ac.each_with_index do |entry, i|
  File.open("#{Dir.pwd}/QC_result.txt", "a") do |f|
    f.puts "-----------------------"
    f.puts entry
    f.puts pm[i]
    f.puts "\n"
  end
end

# pm_paths.each {|path| puts path}

# paths.each do |path|
#   if File.file?(path)
#     location = File.dirname(path)
#     unless folder == location
#       folder = File.dirname(path)
#       sequence += 1
#     end
#     file_name = "%04d_%s" % [sequence, File.basename(path)]
#     File.rename("#{wdir}/#{path}","#{wdir}/#{location}/#{file_name}")
#   end
# end
