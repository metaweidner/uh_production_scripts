require 'yaml'
require 'yaml/store'
require 'pathname'

path = Pathname.new('P:\DigitalProjects\_BCDAMS\0_dev\stats\collections')
path.children.each do |child|

  store = YAML::Store.new(child)

  store.transaction(true) do
    store.roots.each do |ark|
      puts "Processing #{ark}"
      new_store = YAML::Store.new("P:/DigitalProjects/_BCDAMS/0_dev/stats/collections/#{ark}.yml")
      objects = store[ark]['objects']
      new_objects = []
      objects.each do |object|
        images = []
        targets = []
        files = []
        object['images'].each do |image|
          file_name = image['name']
          if file_name.include? '_ac'
            file_type = 'Access'
          elsif file_name.include? '_pm'
            file_type = 'Preservation'
          elsif file_name.include? '_mm'
            file_type = 'Modified Master'
          else
            file_type = 'Unknown'
          end
          creation_date = image['creation_date']
          production_date = image['production_date']
          if image['image_data']['exiftool']['RowsPerStrip'].nil?
            filegeometry = 'Tiled'
          else
            filegeometry = 'Striped'
          end
          filesize = image['image_data']['exiftool']['FileSize']
          width = image['image_data']['exiftool']['ImageWidth']
          height = image['image_data']['exiftool']['ImageHeight']
          compression = image['image_data']['exiftool']['Compression']
          x_dpi = image['image_data']['exiftool']['XResolution']
          y_dpi = image['image_data']['exiftool']['YResolution']
          resolution_unit = image['image_data']['exiftool']['ResolutionUnit']
          software = image['image_data']['exiftool']['Software']
          profile_description = image['image_data']['exiftool']['ProfileDescription']
          new_object = {
            'name' => file_name,
            'creation_date' => creation_date,
            'production_date' => production_date,
            'file_type' => file_type,
            'exiftool' => {
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
          }
          if file_name.include? 'target'
            targets << new_object
          else
            images << new_object
          end
        end
        object['files'].each do |file|
          files << file
        end
        new_objects << { 'images' => images, 'targets' => targets, 'files' => files }
      end
      collection = store[ark]['collection']
      new_store.transaction do
        new_store[ark] = { 'collection' => collection, 'objects' => new_objects }
        store.commit
      end
    end
  end

end
