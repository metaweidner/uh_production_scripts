require 'fileutils'

# get all files/directories recursively
paths = Dir.glob("**/*")
# get current working directory
wdir = Dir.pwd
sdir = "P:/DigitalProjects/_BCDAMS/4_to_ocr/2015_008_beste/Files/AC_TIFF"

paths.each do |path|
  if File.file?(path)
    if File.extname(path) == ".tif"
      location = File.dirname(path)
      file_name = File.basename(path, ".*")
      file_name = file_name[0...-3]

      # puts "Source: #{wdir}/AC_TIFF/#{file_name}.tif"
      # puts "Target: #{wdir}/#{location}/#{file_name}_ac.tif"

      # File.rename("#{wdir}/AC_TIFF/#{file_name}.tif", "#{wdir}/AC_TIFF/#{file_name}_ac.tif")

      File.rename("#{sdir}/#{file_name}.tif", "#{wdir}/#{location}/#{file_name}_ac.tif")
      File.delete("#{wdir}/#{location}/#{file_name}_ac.jpg")
    end

    # file_name = "%04d_%s" % [sequence, File.basename(path)]
    # unless File.extname(path) == ".rb"
    #   File.rename("#{wdir}/#{path}","#{wdir}/#{location}/#{file_name}")
    # end
  end
end
