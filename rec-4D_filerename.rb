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

def rename_image(path)
  # puts path.parent
  filename = path.basename.sub_ext ''
  fileparts = filename.to_s.split('_')
  type = fileparts[-1]
  num = fileparts[-2].to_i
  file_name = "%04d_%s" % [num,type]
  newname = file_name + path.extname
  newpath = path.parent.join(newname)
  path.rename(newpath)
  # path.rename(path.parent.join(file_name + path.extname))
end

pn = Pathname.new('Place-path-here!!')

tiffs = get_images(pn)
tiffs.each {|tiff| rename_image(tiff)}
