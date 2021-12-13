# get all files/directories recursively
paths = Dir.glob("**/*")
# get current working directory
wdir = Dir.pwd

sequence = 0
folder = String.new

paths.each do |path|
  if File.file?(path)
    location = File.dirname(path)
    unless folder == location
      folder = File.dirname(path)
      sequence += 1
    end
    file_name = "%04d_%s" % [sequence, File.basename(path)]
    File.rename("#{wdir}/#{path}","#{wdir}/#{location}/#{file_name}")
  end
end
