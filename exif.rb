# frozen_string_literal: true

module EXIF
  module_function

  class Metadata
    attr_reader :creator, :do, :pm

    def initialize(do_ark, pm_ark)
      @creator = 'University of Houston Libraries'
      @do = do_ark
      @pm = pm_ark
    end
  end

  class Object
    attr_accessor :title, :images

    def initialize()
      @metadata = metadata
      @ac = ac
      @mm = mm
      @size = ac.size + mm.size
    end
  end

  def values(collection, object)
    {
      creator: 'University of Houston Libraries',
      identifier: collection.ark,
      description: collection.title,
      title: object.title
    }
  end

  def add_metadata(path)
    image = MiniExiftool.new path.to_s
    image.title = path.basename.to_s
    image.creator = "University of Houston Libraries"
    image.save
  end

  def exiftool(path)
    image = MiniExiftool.new path
    image.to_hash
  end

  def stats(object, project)
    data = {}
    images = []
    targets = []
    files = []
    object['files'].each do |file|
      path = Pathname.new(file['path'])
      if path.extname == '.tif'
        if path.basename.to_s.include? '_ac'
          filetype = 'Access'
        elsif path.basename.to_s.include? '_pm'
          filetype = 'Preservation'
        elsif path.basename.to_s.include? '_mm'
          filetype = 'Modified Master'
        else
          filetype = 'Unknown'
        end
        exif_data = data(project.join(path))
        if path.basename.to_s.include? 'target'
          targets << {
            'name' => path.basename.to_s,
            'creation_date' => File.ctime(project.join(path)),
            'production_date' => Time.now,
            'file_type' => filetype,
            'exiftool' => image_data(exif_data['exiftool'], path)
          }
        else
          images << {
            'name' => path.basename.to_s,
            'creation_date' => File.ctime(project.join(path)),
            'production_date' => Time.now,
            'file_type' => filetype,
            'exiftool' => image_data(exif_data['exiftool'], path)
          }
        end
      else
        files << {
          'name' => path.basename.to_s,
          'creation_date' => File.ctime(project.join(path)),
          'production_date' => Time.now
        }
      end
    end
    data['images'] = images
    data['targets'] = targets
    data['files'] = files
    data
  end

  def image_data(data, image)
    if data['RowsPerStrip'].nil?
      filegeometry = 'Tiled'
    else
      filegeometry = 'Striped'
    end
    filesize = data['FileSize']
    width = data['ImageWidth']
    height = data['ImageHeight']
    compression = data['Compression']
    x_dpi = data['XResolution']
    y_dpi = data['YResolution']
    resolution_unit = data['ResolutionUnit']
    software = data['Software']
    profile_description = data['ProfileDescription']
    {
      'geometry' => filegeometry,
      'size' => filesize,
      'x_dpi' => x_dpi,
      'y_dpi' => y_dpi,
      'resolution_unit' => resolution_unit,
      'profile_description' => profile_description,
      'compression' => compression,
      'width' => width,
      'height' => height,
      'software' => software
    }
  end

  def row(path)
    qc(data(path), path)
  end

  def data(path)
    data = exiftool(path.to_s.gsub('\\','/'))
    {'exiftool' => data}
  end

  def qc(data, image)
    directory = image.parent
    filename = image.basename
    if image.basename.to_s.include? '_ac'
      filetype = 'Access'
    elsif image.basename.to_s.include? '_pm'
      filetype = 'Preservation'
    elsif image.basename.to_s.include? '_mm'
      filetype = 'Modified Master'
    else
      filetype = 'Unknown'
    end
    if data['exiftool']['RowsPerStrip'].nil?
      filegeometry = 'Tiled'
    else
      filegeometry = 'Striped'
    end
    filesize = data['exiftool']['FileSize']
    orientation = data['exiftool']['Orientation']
    width = data['exiftool']['ImageWidth']
    height = data['exiftool']['ImageHeight']
    bit_depth = data['exiftool']['BitsPerSample']
    compression = data['exiftool']['Compression']
    x_dpi = data['exiftool']['XResolution']
    y_dpi = data['exiftool']['YResolution']
    resolution_unit = data['exiftool']['ResolutionUnit']
    software = data['exiftool']['Software']
    sharpening = data['exiftool']['Sharpness']
    sharpening_radius = data['exiftool']['SharpenRadius']
    profile_description = data['exiftool']['ProfileDescription']
    title = data['exiftool']['Title']
    creator = data['exiftool']['Creator']
    [ 
      directory,
      filename,
      filetype,
      filegeometry,
      filesize,
      x_dpi,
      y_dpi,
      resolution_unit,
      profile_description,
      compression,
      bit_depth,
      orientation,
      width,
      height,
      software,
      sharpening,
      sharpening_radius,
      title,
      creator
    ]
  end

  def header
    [
      "Directory", 
      "File Name",
      "File Type",
      "File Geometry",
      "File Size",
      "X DPI",
      "Y DPI",
      "Resolution Unit",
      "Profile Description",
      "Compression",
      "Bit Depth",
      "Orientation",
      "Width",
      "Height",
      "Software",
      "Sharpening",
      "Sharpening Radius",
      "Title",
      "Creator"
    ]
  end

end
