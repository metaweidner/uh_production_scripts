require 'pathname'
require 'fileutils'
require_relative "../lib/bcdams.rb"

directory = 'P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\2015_008_beste\Files'
images = BCDAMS.get_images(Pathname.new(directory))

images.each do |image|
  if image.basename.to_s.include? '_ac'
    dir = image.parent.to_s
    filename = image.basename.to_s.gsub('_ac','_mm')
    path = File.join(dir, filename)
    puts path
    FileUtils.cp(image, path)
  end
end