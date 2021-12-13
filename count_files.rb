require 'pathname'

def get_images(path, images = [])
  path.children.each do |child|
    if File.directory? child
      get_images child, images
    else
      if child.extname == '.tif'
        images << child
      end
    end
  end
  images
end

path = Pathname.new('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\55612490_montrose_star\Files')
tiffs = get_images(path)

ac = 0
pm = 0
target = 0
tiffs.each do |tiff|
  basename = tiff.basename.to_s
  if basename.include? 'pm'
    if basename.include? 'target'
      target += 1
    else
      pm += 1
    end
  else
    ac += 1
  end
end

puts "ac = #{ac}"
puts "pm = #{pm}"
puts "target = #{target}"
