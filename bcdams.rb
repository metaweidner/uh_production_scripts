# frozen_string_literal: true

module BCDAMS
  module_function

  def main_menu
    choices = {
      '2.1 Create Digi Production Directory' => 'digiProduction',
      '2.2 Digi QC: Production (Process)' => 'digiQC-production-process',
      '2.2 Digi QC: Production (Files)' => 'digiQC-production-files',
      '2.2 Count Image Types (Files)' => 'digiCount',
      '2.2 Find Count Mismatches (Files)' => 'digiFind',
      '2.3.1 Rename Digi Files' => 'digiRename',
      '2.3.2 Delete Digi Metadata' => 'digiDelete',
      '2.3.3 Add EXIF Metadata' => 'addMetadata',
      '2.3.4 Add AC Color Profile' => 'colorProfile',
      '2.3.5 Convert AC to Pyramidal' => 'convertPyramidal',
      '2.3.6 Digi QC: Carp' => 'digiQC-carp',
      '2.3.7 Store Project Stats' => 'projectStats',
      'Quit' => 'Quit'
    }
    prompt = TTY::Prompt.new
    prompt.select('Main Menu:', choices, per_page: 13, cycle: true)
  end

  def migration_menu
    prompt = TTY::Prompt.new
    choices = {
      'Digi QC: Migration' => 'digiQC-migration',
      'Rename Digi Files' => 'digiRename',
      # '2.3.2 Delete Digi Metadata' => 'digiDelete',
      'Add EXIF Metadata' => 'addMetadata',
      'Add AC Color Profile' => 'colorProfile',
      'Convert AC to Pyramidal' => 'convertPyramidal',
      'Digi QC: Carp' => 'digiQC-carp',
      # '2.3.7 Store Project Stats' => 'projectStats',
      'Quit' => 'Quit'
    }
    prompt.select('Main Menu:', choices, per_page: 13)
  end

  def intro(path)
    print_tree(path)
    get_choices(path)
  end

  def prompt(label, choices)
    prompt = TTY::Prompt.new
    prompt.select(label, choices, per_page: 15, cycle: true)
  end

  def print_tree(path)
    display_path = path.to_s
    width = display_path.length + 2
    top_box = TTY::Box.frame(border: :ascii, width: width) { display_path }
    bottom_box = TTY::Box.frame(border: { type: :ascii, bottom: false }, width: width, height: 1)
    tree = TTY::Tree.new(path, level: 2)
    print top_box
    print tree.render
    print bottom_box
  end

  def get_choices(path)
    choices = {}
    choices['.. (Main Menu)'] = 'Main Menu'
    projects = Pathname.new(path).children
    projects.each do |path|
      unless path.basename.to_s == '0_downloads_archive'
        choices[path.basename] = path
      end
    end
    choices
  end

  def get_carp_files(project, function)
    carp_files = {}
    carp_files[".. (#{function} Projects Menu)"] = 'Projects Menu'
    project.each_child do |child|
      carp_files[child.basename] = child if child.extname == '.carp'
    end
    carp_files
  end

  def get_shotlists(project, function)
    shotlists = {}
    shotlists[".. (#{function} Projects Menu)"] = 'Projects Menu'
    project.each_child do |child|
      shotlists[child.basename] = child if child.extname == '.csv'
    end
    shotlists
  end

  def read_carp_file(path)
    file = File.read(path)
    carp = JSON.parse(file)
    carp
  end

  def new_spinner(message)
    pastel = Pastel.new
    spinner_format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("#{message} ...")
    spinner = TTY::Spinner.new(spinner_format, success_mark: pastel.green('+'))
  end

  def no_file(name, function, config, log)
    pastel = Pastel.new
    prompt = TTY::Prompt.new
    puts pastel.red("There are no #{name} files in this directory.")
    prompt.keypress('Press space or enter to continue...', keys: %i[space return])
    execute function, config, log
  end

  def no_dir(name, function, config, log)
    pastel = Pastel.new
    prompt = TTY::Prompt.new
    puts pastel.red("There is no #{name} directory in this project.")
    prompt.keypress('Press space or enter to continue...', keys: %i[space return])
    execute function, config, log
  end

  # def digi(path, digi_tif)
  #   path.children.each do |child|
  #     if File.directory? child
  #       digi child, digi_tif
  #     else
  #       digi_tif << child if child.extname == '.tif'
  #     end
  #   end
  #   digi_tif
  # end

  # def archive(object, collection_ark, bar, archive, project)
  #   collection_path = archive.join(collection_ark)
  #   do_ark = Pathname.new(object['do_ark']).basename
  #   object_path = collection_path.join(do_ark)
  #   ocr_path = object_path.join('ocr')
  #   FileUtils.mkdir_p ocr_path
  #   object['files'].each do |file|
  #     next unless file['purpose'] == 'sub-documents'
  #     path = Pathname.new(file['path'])
  #     case path.extname
  #     when '.pdf'
  #       FileUtils.cp project.join(path), object_path.join(path.basename)
  #     when '.epub'
  #       FileUtils.cp project.join(path), object_path.join(path.basename)
  #     when '.txt'
  #       unless path.to_s.include? 'digi'
  #         FileUtils.cp project.join(path), object_path.join(path.basename)
  #       end
  #     when '.yml'
  #       FileUtils.cp project.join(path), object_path.join(path.basename)
  #     when '.xml'
  #       FileUtils.cp project.join(path), ocr_path.join(path.basename)
  #     end
  #   end
  #   bar.advance(1)
  # end

  def get_ark(collection, function, config)
    match_query = RDF::Query.new(
      match: { RDF::URI('http://sindice.com/vocab/search#totalResults') => :result }
    )
    link_query = RDF::Query.new(
      link: { RDF::URI('http://sindice.com/vocab/search#link') => :uri }
    )
    id_query = RDF::Query.new(
      id: { RDF::URI('http://www.w3.org/2004/02/skos/core#exactMatch') => :ark }
    )

    search = URI.escape("https://vocab.lib.uh.edu/search.ttl?depth=5&l=en&for=concept&q=#{collection}&qt=exact&t=labels")
    search.gsub!("a\%CC\%81", "\%C3\%A1")
    search.gsub!("e\%CC\%81", "\%C3\%A9")
    search.gsub!("i\%CC\%81", "\%C3\%AD")
    search.gsub!("o\%CC\%81", "\%C3\%B3")
    search.gsub!("u\%CC\%81", "\%C3\%BA")
    begin
      graph = RDF::Graph.load(search.to_s)
    rescue StandardError
      puts "ERROR: Cedar 501 for \'#{collection}\'"
      puts search
      execute function, config, log
    end

    results = match_query.execute(graph)
    if results.first[:result].to_i == 1
      link = link_query.execute(graph)
      id = id_query.execute(RDF::Graph.load("#{link.first[:uri]}.ttl"))
      ark = id.first[:ark]
    else
      ark = nil
    end
    ark
  end

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

  def cleanup(path)
    path.children.each do |child|
      if File.directory? child
        cleanup child
      else
        if child.extname == '.tif_original'
          File.delete(child)
        end
      end
    end
  end

  def get_objects(path, directories = [])
    path.children.each do |child|
      if File.directory?(child)
        get_objects(child, directories)
      else
        directories << path unless directories.include? path
      end
    end
    directories
  end

  def get_counts(path)
    ac, mm, pm, target, unknown = 0, 0, 0, 0, 0
    path.children.each do |child|
      if child.extname == '.tif'
        basename = child.basename.to_s
        if basename.include? 'pm'
          if basename.include? 'target'
            target += 1
          else
            pm += 1
          end
        elsif basename.include? 'mm'
          mm += 1
        elsif basename.include? 'ac'
          ac += 1
        else
          unknown += 1
        end          
      end
    end
    {'path'=>path,'ac'=>ac,'mm'=>mm,'pm'=>pm,'target'=>target,'unknown'=>unknown}
  end

  def file_count_headers()
    [
      'Path',
      'AC',
      'MM',
      'PM',
      'Target',
      'Unknown'
    ]
  end

  def file_counts(object)
    [
      object['path'],
      object['ac'],
      object['mm'],
      object['pm'],
      object['target'],
      object['unknown']
    ]
  end

  def timestamp()
    time = Time.now
    time.strftime("%Y%m%d-%H%M")
  end

  def convert_to_pyramidal(tiff)
    system("convert #{tiff} -quiet -compress jpeg -quality 90 -define tiff:tile-geometry=256x256 ptif:#{tiff}")
  end

  def add_color_profile(tiff, profile)
    system("convert #{tiff} -quiet -colorspace #{profile.keys.first.to_s} -profile #{profile.values.first.to_s} #{tiff}")
  end

end
