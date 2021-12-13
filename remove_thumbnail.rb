require 'multi_exiftool'
require 'mini_exiftool'
require 'pathname'
require 'fileutils'



filepath = Pathname.new('P:\DigitalProjects\_BCDAMS\0_dev\workflow\dev\exiftool_thumbnails\0017_0146_ac.tif')

system("P:\\DigitalProjects\\_BCDAMS\\0_dev\\workflow\\exiftool.exe -ifd1:all= -m #{filepath.to_s}")
