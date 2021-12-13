require 'mini_exiftool'
require 'pathname'
require 'fileutils'

MiniExiftool.command = 'P:\DigitalProjects\_BCDAMS\0_dev\workflow\exiftool.exe'

image = MiniExiftool.new filepath



# image.tags.sort.each do |tag|
#   puts tag.ljust(28) + image[tag].to_s
# end
