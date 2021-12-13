require 'pathname'

def get_images(path)
  targets = []
  count = 0
  path.children.each do |child|
    if File.directory? child
      get_images child
    else
      if child.extname == '.tif'
        if child.basename.to_s.include? 'target'
          targets << child
        else
          rename_image(child)
        end
      end
    end
  end
  targets.each do |target|
    count += 1
    rename_target(target, count)
  end
end

def rename_image(path)
  filename = path.basename.sub_ext ''
  fileparts = filename.to_s.split('_')
  type = fileparts[-1]
  num = fileparts[-2].to_i
  file_name = "%04d_%s" % [num,type]
  newname = file_name + path.extname
  newpath = path.parent.join(newname)
  path.rename(newpath)
end

def rename_target(path, count)
  filename = path.basename.sub_ext ''
  fileparts = filename.to_s.split('_')
  type = fileparts[-1]
  file_name = "target_%04d_%s" % [count,type]  
  newname = file_name + path.extname
  newpath = path.parent.join(newname)
  path.rename(newpath)
end

path = Pathname.new('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\4305754_texaco_post-1964\Files')
get_images(path)
