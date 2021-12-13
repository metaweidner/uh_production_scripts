# imagemagick command line
# convert 0001_ac.tif -compress deflate -quality 90 -define tiff:tile-geometry=256x256 ptif:output_1.tif

system("convert P:\\DigitalProjects\\_BCDAMS\\2_to_digi\\2_to_production\\2018_017_shell_news\\Production\\pyramidal_test\\0001_ac.tif -compress lzw -quality 90 -define tiff:tile-geometry=256x256 ptif:P:\\DigitalProjects\\_BCDAMS\\2_to_digi\\2_to_production\\2018_017_shell_news\\Production\\pyramidal_test\\output_1.tif")

# require 'mini_magick'

# image = MiniMagick::Image.open('P:\DigitalProjects\_BCDAMS\2_to_digi\2_to_production\2018_017_shell_news\Production\pyramidal_test\0001_ac.tif')

# image.combine_options do |tiff|
#   tiff.compress 'lzw'
#   tiff.quality '90'
#   tiff.define "tiff:tile-geometry=256x256 ptif:P:\\DigitalProjects\\_BCDAMS\\2_to_digi\\2_to_production\\2018_017_shell_news\\Production\\pyramidal_test\\output_2.tif"
# end