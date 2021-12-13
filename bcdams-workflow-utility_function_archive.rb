  when 'ingestRename'
    function_path = config.fetch(:ingestRename)
    BCDAMS.print_tree function_path
    choices = BCDAMS.get_choices function_path
    project = prompt.select('Rename Ingest Files:', choices, per_page: 15)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute function, config
    else
      carp_files = BCDAMS.get_carp_files project, 'Rename Ingest Files'
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute function, config
        else
          carp_name = path.basename.sub_ext ''
          carp = BCDAMS.read_carp_file path
          spinner = BCDAMS.new_spinner 'Renaming Files for Ingest'
          spinner.auto_spin
          carp['objects'].each do |object|
            do_ark = object['do_ark'].split('/')[-1]
            full_object = []
            # xml = []
            # tif = []
            object['files'].each do |file|
              path = Pathname.new(file['path'])
              case path.extname
              when '.pdf'
                full_object << path
              when '.epub'
                full_object << path
              when '.txt'
                full_object << path
              # when '.yml'
              #   full_object << path
              # when '.xml'
              #   xml << path
              # when '.tif'
              #   tif << path
              end
            end
            names = {
              'project' => project,
              'do_ark' => do_ark,
              'carp_name' => carp_name.to_s
            }
            full_object.each do |path|
              Rename.full_object path, names
            end
            # xml.each do |path|
            #   Rename.xml path, names
            # end
            # targets = []
            # tif.each do |path|
            #   if path.basename.to_s.include? 'target'
            #     targets << path
            #   else
            #     Rename.tif path, names
            #   end
            # end
            # Rename.targets targets, names
          end
          spinner.success(pastel.green('Ingest Files Renamed!'))
          function = BCDAMS.main_menu
          execute function, config
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'addExif'
    MiniExiftool.command = config.fetch(:exifTool)
    function_path = config.fetch(:addExif)
    BCDAMS.print_tree function_path
    choices = BCDAMS.get_choices function_path
    project = prompt.select('Add EXIF Metadata:', choices, per_page: 15)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute function, config
    else
      carp_files = BCDAMS.get_carp_files project, 'Add EXIF Metadata'
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute function, config
        else
          carp = BCDAMS.read_carp_file path
          objects = []
          carp['objects'].each do |object|
            ac_files = []
            mm_files = []
            object['files'].each do |file|
              path = Pathname.new(file['path'])
              next unless path.extname == '.tif'

              basename = path.basename.sub_ext ''
              type = basename.to_s.split('_')[-1]
              case type
              when 'ac'
                ac_files << project + path
              when 'mm'
                mm_files << project + path
              end
            end
            metadata = EXIF::Metadata.new object['do_ark'], object['pm_ark']
            object = EXIF::Object.new metadata, ac_files, mm_files
            objects << object
          end
          total = 0
          objects.each { |object| total += object.size }
          bar = TTY::ProgressBar.new('Add EXIF Metadata [:bar] :percent :elapsed', total: total)
          bar.start
          objects.each do |object|
            tiffs = object.ac + object.mm
            tiffs.each { |path| EXIF.add path, object.metadata, bar }
          end
          puts pastel.green('EXIF Metadata Added!')
          function = BCDAMS.main_menu
          execute function, config
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'addDescMeta'
    function_path = config.fetch(:addDescMeta)
    BCDAMS.print_tree function_path
    choices = BCDAMS.get_choices function_path
    project = prompt.select('Add Descriptive Metadata:', choices, per_page: 15)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute function, config
    else
      carp_files = BCDAMS.get_carp_files project, 'Add Descriptive Metadata'
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute function, config
        else
          carp_name = path.basename.sub_ext ''
          carp = BCDAMS.read_carp_file path
          spinner = BCDAMS.new_spinner 'Adding Descriptive Metadata'
          spinner.auto_spin
          carp['objects'].each do |object|
            do_ark = object['do_ark'].split('/')[-1]
            object_path, base = Pathname.new(object['files'][0]['path']).split
            fp = project + object_path
            TTY::File.create_file "#{fp}/#{carp_name}_#{do_ark}_desc_metadata.yml", object['metadata'].to_yaml, verbose: false
          end
          spinner.success(pastel.green('Descriptive Metadata Added!'))
          function = BCDAMS.main_menu
          execute function, config
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'archiveDownloads'
    function_path = config.fetch(:archiveDownloads)
    BCDAMS.print_tree function_path
    choices = BCDAMS.get_choices function_path
    project = prompt.select('Archive Downloads:', choices, per_page: 15)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute function, config
    else
      carp_files = BCDAMS.get_carp_files project, 'Archive Downloads'
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute function, config
        else
          carp = BCDAMS.read_carp_file path
          print pastel.yellow("Retrieving Collection ARK ... ")
          if carp['type'] == 'standard'
            ark = Pathname.new(carp['collectionArkUrl']).basename
          else
            collection = carp['collectionTitle']
            ark_uri = BCDAMS.get_ark collection, function, config
            ark = Pathname.new(ark_uri).basename
          end
          if ark == 'Collection ARK Not Found'
            puts pastel.red("#{ark} for \'#{collection}\'")
            prompt.keypress('Press space or enter to continue...', keys: %i[space return])
            execute function, config
          else
            puts pastel.green("Found: #{ark}")
            archive = Pathname.new(config.fetch(:downloadsArchive))
            total = carp['objects'].size
            bar = TTY::ProgressBar.new("Archiving #{ark} [:bar] :percent :elapsed", total: total)
            bar.start
            carp['objects'].each do |object|
              BCDAMS.archive object, ark, bar, archive, project
            end
            puts pastel.green('Downloads Archived!')
            function = BCDAMS.main_menu
            execute function, config
          end
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

