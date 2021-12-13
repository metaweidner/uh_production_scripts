# frozen_string_literal: true

require 'tty-config'
require 'tty-box'
require 'tty-prompt'
require 'tty-tree'
require 'tty-file'
require 'tty-spinner'
require 'tty-reader'
require 'ruby-progressbar'
require 'pastel'
require 'json'
require 'yaml'
require 'yaml/store'
require 'csv'
require 'pathname'
require 'fileutils'
require 'mini_exiftool'
# require 'multi_exiftool'
require 'open-uri'
require 'uri'
require 'linkeddata'
require 'logger'

require_relative 'lib/bcdams'
require_relative 'lib/carp'
require_relative 'lib/exif'

def execute(function, config, log)
  prompt = TTY::Prompt.new
  pastel = Pastel.new

  case function

  when 'digiProduction'
    choices = BCDAMS.intro(config.fetch(:digiProduction))
    project = BCDAMS.prompt('Create Digi Production Directory:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      shotlists = BCDAMS.get_shotlists project, 'Digi Production Directory'
      if shotlists.size > 1
        path = prompt.select('Choose a shotlist:', shotlists)
        if path == 'Projects Menu'
          execute(function, config, log)
        else
          spinner = BCDAMS.new_spinner 'Creating Production Directory'
          spinner.auto_spin
          dir, basename = path.split
          FileUtils.mkdir_p "#{dir}/Documentation"
          carp_files = BCDAMS.get_carp_files project, function
          carp_files.each do |k, v|
            if v.to_s.include? '.carp'
              FileUtils.cp(v, "#{dir}/Documentation/#{v.basename}")
            end
          end
          FileUtils.mkdir_p "#{dir}/Production/1_exports"
          FileUtils.mkdir_p "#{dir}/Production/2_to_process"
          FileUtils.mkdir_p "#{dir}/Production/3_completed"
          shotlist = CSV.read(path, headers: true)
          shotlist.each do |row|
            folder = row['Location']
            title = row['Title']
            note = row['Notes']
            FileUtils.mkdir_p "#{dir}/Production/Files/#{folder}/ac"
            FileUtils.mkdir_p "#{dir}/Production/Files/#{folder}/pm"
            File.write("#{dir}/Production/Files/#{folder}/metadata.txt", "title: #{title}\nlocation: #{folder}\nnote: #{note}\n")
          end
          FileUtils.mv(path, "#{dir}/Documentation/#{basename}")
          File.open("#{dir}/Documentation/createProductionDirectory.log", 'a') do |f|
            f.puts Time.now
            f.puts project
            f.puts "Successfully created \'Production\' directory."
            f.puts "\n"
          end
          spinner.success(pastel.green('Production Directory Created'))
          prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
          function = BCDAMS.main_menu
          execute(function, config, log)
        end
      else
        BCDAMS.no_file 'shotlist', function, config, log
      end
    end

  when 'digiRename'
    choices = BCDAMS.intro(config.fetch(:digiRename))
    project = BCDAMS.prompt('Rename Digi Files:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      if File.directory?(project.join('Files'))
        response = prompt.yes?("Rename files for #{pastel.yellow(project.basename)}?")
        if response
          spinner = BCDAMS.new_spinner 'Getting Digi Files'
          spinner.auto_spin
          sequence = 0
          files = project.join('Files')
          tif = BCDAMS.get_images files
          spinner.success(pastel.green("Found #{tif.size}"))
          parent = ''
          bar = ProgressBar.create(total: tif.size, format: 'Renaming Files: %c/%C |%W| %a')
          tif.each do |image|
            unless parent == image.dirname.to_s
              parent = image.dirname.to_s
              sequence += 1
            end
            new_name = format('%04d_%s', sequence, image.basename)
            image.rename("#{image.dirname}\\#{new_name}")
            bar.increment
          end
          log.info("#{BCDAMS.timestamp} : renamed Digi files for #{project.basename}")
          puts pastel.green('Digi Files Renamed')
          prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
          function = BCDAMS.main_menu
          execute(function, config, log)
        else
          execute(function, config, log)
        end
      else
        BCDAMS.no_dir 'Files', function, config, log
      end
    end

  when 'digiCount'
    choices = BCDAMS.intro(config.fetch(:digiCount))
    project = BCDAMS.prompt('Count Image Types:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      if File.directory?(project.join("Files"))
        spinner = BCDAMS.new_spinner 'Getting Images'
        spinner.auto_spin
        files = project.join('Files')
        tiffs = BCDAMS.get_images files
        spinner.success(pastel.green("Found #{tiffs.size}"))
        ac, mm, pm, target, unknown = 0, 0, 0, 0, 0
        spinner = BCDAMS.new_spinner 'Counting Types'
        spinner.auto_spin
        tiffs.each do |tiff|
          basename = tiff.basename.to_s
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
        spinner.success(pastel.green("Done"))
        display_str = project.basename.to_s
        width = display_str.length + 2
        print TTY::Box.frame(border: :ascii, width: width) { display_str }
        puts "AC = #{ac}"
        puts "MM = #{mm}" if mm > 0
        puts "PM = #{pm}"
        puts "Target = #{target}"
        puts "Unknown = #{unknown}" if unknown > 0
        print TTY::Box.frame(border: { type: :ascii, bottom: false }, width: width, height: 1)
        prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
        function = BCDAMS.main_menu
        execute(function, config, log)
      else
        BCDAMS.no_dir 'Files', function, config, log
      end
    end

  when 'digiFind'
    choices = BCDAMS.intro(config.fetch(:digiFind))
    project = BCDAMS.prompt('Find Count Mismatches:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      if File.directory?(project.join("Files"))
        spinner = BCDAMS.new_spinner 'Getting Objects'
        spinner.auto_spin
        files = project.join('Files')
        objects = BCDAMS.get_objects(files)
        spinner.success(pastel.green("Found #{objects.size}"))
        mismatches = []
        bar = ProgressBar.create(total: objects.size, format: 'Comparing File Counts: %c/%C |%W| %a')
        objects.each do |object|
          bar.increment
          counts = BCDAMS.get_counts(object)
          if counts['ac'] == counts['pm']
            next
          else
            mismatches << counts
          end
        end
        if mismatches.size == 0
          puts pastel.green('No Mismatches Found')
        else
          puts pastel.red("Mismatches Found: #{mismatches.size}")
          spinner = BCDAMS.new_spinner 'Writing Report'
          spinner.auto_spin
          time = BCDAMS.timestamp
          FileUtils.mkdir_p "#{project}\\Documentation"
          report = "#{project}\\Documentation\\#{project.basename}_digi_file_count_mismatches_#{time}.csv"
          CSV.open(report, 'w') do |csv|
            csv << BCDAMS.file_count_headers
            mismatches.each do |object|
              csv << BCDAMS.file_counts(object)
            end
          end
          spinner.success(pastel.green(report))
        end
        prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
        function = BCDAMS.main_menu
        execute(function, config, log)
      else
        BCDAMS.no_dir 'Files', function, config, log
      end
    end

  when 'digiDelete'
    choices = BCDAMS.intro(config.fetch(:digiDelete))
    project = BCDAMS.prompt('Delete Digi Metadata:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      response = prompt.yes?("Delete Metadata for #{pastel.yellow(project.basename)}?")
      if response
        spinner = BCDAMS.new_spinner 'Deleting Metadata Files'
        spinner.auto_spin
        Dir.chdir(project.join('Files'))
        metadata = Dir.glob(File.join("**","metadata.txt"))
        metadata.each { |f| File.delete(f) }
        spinner.success(pastel.green("#{metadata.size} deleted"))
      else
        execute(function, config, log)
      end
      log.info("#{BCDAMS.timestamp} : deleted #{metadata.size} Digi metadata files for #{project.basename}")
      prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
      function = BCDAMS.main_menu
      execute(function, config, log)
    end

  when 'digiQC-production-process'
    MiniExiftool.command = config.fetch(:exifTool)
    choices = BCDAMS.intro(config.fetch(:digiQC_production))
    project = BCDAMS.prompt('Digi Production (Process) QC:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      if File.directory?(project.join('Production/2_to_process'))
        spinner = BCDAMS.new_spinner 'Getting TIFF Images'
        spinner.auto_spin
        images_path = project.join('Production/2_to_process')
        images = BCDAMS.get_images(images_path)
        spinner.success(pastel.green("Found #{images.size} TIFFs"))
        time = BCDAMS.timestamp
        FileUtils.mkdir_p "#{project}\\Documentation"
        bar = ProgressBar.create(total: images.size, format: 'Compiling EXIF Metadata: %c/%C |%W| %a')
        CSV.open("#{project}\\Documentation\\#{project.basename}_production_process_qc_#{time}.csv", 'w') do |csv|
          csv << EXIF.header
          images.each do |image|
            csv << EXIF.row(project.join(image))
            bar.increment
          end
        end
        puts pastel.green('Digi Production (Process) QC Complete')
        prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
        function = BCDAMS.main_menu
        execute(function, config, log)
      else
        BCDAMS.no_dir 'Production/2_to_process', function, config, log
      end
    end

  when 'digiQC-production-files'
    MiniExiftool.command = config.fetch(:exifTool)
    choices = BCDAMS.intro(config.fetch(:digiQC_production))
    project = BCDAMS.prompt('Digi Production (Files) QC:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      if File.directory?(project.join('Production/Files'))
        spinner = BCDAMS.new_spinner 'Getting TIFF Images'
        spinner.auto_spin
        images_path = project.join('Production/Files')
        images = BCDAMS.get_images(images_path)
        spinner.success(pastel.green("Found #{images.size} TIFFs"))
        time = BCDAMS.timestamp
        FileUtils.mkdir_p "#{project}\\Documentation"
        bar = ProgressBar.create(total: images.size, format: 'Compiling EXIF Metadata: %c/%C |%W| %a')
        CSV.open("#{project}\\Documentation\\#{project.basename}_production_files_qc_#{time}.csv", 'w') do |csv|
          csv << EXIF.header
          images.each do |image|
            csv << EXIF.row(project.join(image))
            bar.increment
          end
        end
        puts pastel.green('Digi Production (Files) QC Complete')
        prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
        function = BCDAMS.main_menu
        execute(function, config, log)
      else
        BCDAMS.no_dir 'Production/Files', function, config, log
      end
    end

  when 'digiQC-migration'
    MiniExiftool.command = config.fetch(:exifTool)
    choices = BCDAMS.intro(config.fetch(:digiQC_migration))
    workflow_stage = prompt.select('Migration Digi QC:', choices, per_page: 15, cycle: true)
    if workflow_stage == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      choices = BCDAMS.get_choices workflow_stage
      project = prompt.select('Migration Digi QC Project:', choices, per_page: 15, cycle: true)
      if project == 'Main Menu'
        function = BCDAMS.main_menu
        execute(function, config, log)
      else
        spinner = BCDAMS.new_spinner 'Getting TIFF Images'
        spinner.auto_spin
        images_path = project.join('images')
        images = BCDAMS.get_images(images_path)
        spinner.success(pastel.green("Found #{images.size} TIFFs"))
        time = BCDAMS.timestamp
        FileUtils.mkdir_p "#{project}\\Documentation"
        bar = ProgressBar.create(total: images.size, format: 'Compiling EXIF Metadata: %c/%C |%W| %a')
        CSV.open("#{project}\\Documentation\\#{project.basename}_migration_qc_#{time}.csv", 'w') do |csv|
          csv << EXIF.header
          images.each do |image|
            csv << EXIF.row(project.join(image))
            bar.increment
          end
        end
        puts pastel.green('Digi Migration QC Complete')
        prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
        function = BCDAMS.main_menu
        execute(function, config, log)
      end
    end

  when 'convertPyramidal'
    choices = BCDAMS.intro(config.fetch(:convertPyramidal))
    project = BCDAMS.prompt('Convert TIFFs to Pyramidal:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      response = prompt.yes?("Convert AC TIFFs to pyramidal for #{pastel.yellow(project.basename)}?")
      if response
        spinner = BCDAMS.new_spinner 'Getting AC TIFF Images'
        spinner.auto_spin
        images_path = project.join('Files')
        images = BCDAMS.get_images(images_path)
        ac_images = []
        images.each do |image|
          ac_images << image if image.basename.to_s.include? '_ac'
        end
        spinner.success(pastel.green("Found #{ac_images.size} TIFFs"))
        bar = ProgressBar.create(total: ac_images.size, format: 'Converting AC TIFFs: %c/%C |%W| %a')
        ac_images.each do |image|
          BCDAMS.convert_to_pyramidal(image)
          bar.increment
        end
      else
        execute(function, config, log)
      end
      log.info("#{BCDAMS.timestamp} : converted AC TIFFs to pyramidal for #{project.basename}")
      puts pastel.green('TIFF Conversion Complete')
      prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
      function = BCDAMS.main_menu
      execute(function, config, log)
    end

  when 'colorProfile'
    choices = BCDAMS.intro(config.fetch(:colorProfile))
    project = BCDAMS.prompt('Add Color Profile:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      response = prompt.yes?("Define sRGB color profile AC TIFFs for #{pastel.yellow(project.basename)}?")
      if response
        spinner = BCDAMS.new_spinner 'Getting AC TIFF Images'
        spinner.auto_spin
        images_path = project.join('Files')
        images = BCDAMS.get_images(images_path)
        ac_images = []
        images.each do |image|
          ac_images << image if image.basename.to_s.include? '_ac'
        end
        spinner.success(pastel.green("Found #{ac_images.size} TIFFs"))
        bar = ProgressBar.create(total: ac_images.size, format: 'Updating AC Color Profile: %c/%C |%W| %a')
        sRGB = config.fetch(:sRGB)
        ac_images.each do |image|
          BCDAMS.add_color_profile(image, {'sRGB' => sRGB})
          bar.increment
        end
      else
        execute(function, config, log)
      end
      log.info("#{BCDAMS.timestamp} : defined sRGB color profile AC TIFFs for #{project.basename}")
      puts pastel.green('AC TIFF Color Profile Updated')
      prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
      function = BCDAMS.main_menu
      execute(function, config, log)
    end

  when 'addMetadata'
    choices = BCDAMS.intro(config.fetch(:addMetadata))
    project = BCDAMS.prompt('Add EXIF Metadata:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      carp_files = Carp.files project, '2.3.3 Add EXIF Metadata'
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute(function, config, log)
        else
          print pastel.yellow('Retrieving Collection Data ... ')
          app_data = {
            'function' => function,
            'config' => config,
            'log' => log
          }
          collection = Carp::Collection.new(Carp.read(path), app_data)
          puts pastel.green('Done')
          response = prompt.yes?("Update EXIF for #{collection.size} TIFFs?")
          if response
            collection.objects.each do |object|
              spinner = BCDAMS.new_spinner "\'#{object.title}\' (#{object.size})"
              spinner.auto_spin
              batch = MultiExiftool::Batch.new
              values = EXIF.values(collection, object)
              object.images.each do |image|
                batch.write project.join(image), values
              end
              if batch.execute
                spinner.success(pastel.green("Updated #{object.size} TIFFs"))
              else
                spinner.error(pastel.red("Please check the log for error details"))
                log.error("#{BCDAMS.timestamp} : write EXIF metadata for #{project.basename} : #{batch.errors}")
              end
            end
            spinner = BCDAMS.new_spinner 'Cleaning up'
            spinner.auto_spin
            BCDAMS.cleanup(project.join('Files'))
            spinner.success(pastel.green("Done"))
            log.info("#{BCDAMS.timestamp} : added EXIF metadata for #{project.basename}")
            prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
            function = BCDAMS.main_menu
            execute(function, config, log)
          else
            execute(function, config, log)
          end
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'digiQC-carp'
    MiniExiftool.command = config.fetch(:exifTool)
    choices = BCDAMS.intro(config.fetch(:digiQC_carp))
    project = BCDAMS.prompt('Carp Digi QC:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      carp_files = BCDAMS.get_carp_files project, function
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute(function, config, log)
        else
          carp = BCDAMS.read_carp_file path
          spinner = BCDAMS.new_spinner 'Getting TIFF Images'
          spinner.auto_spin
          images = []
          carp['objects'].each do |object|
            object['files'].each do |file|
              path = Pathname.new(file['path'])
              images << path if path.extname == '.tif'
            end
          end
          spinner.success(pastel.green("Found #{images.size} TIFFs"))
          bar = ProgressBar.create(total: images.size, format: 'Compiling EXIF Metadata: %c/%C |%W| %a')
          time = BCDAMS.timestamp
          FileUtils.mkdir_p "#{project}\\Documentation"
          CSV.open("#{project}\\Documentation\\#{project.basename}_carp_qc_#{time}.csv", 'w') do |csv|
            csv << EXIF.header
            images.each do |image|
              begin
                csv << EXIF.row(project.join(image))
              rescue MiniExiftool::Error => error
                puts pastel.red(error.message)
                puts pastel.yellow("Check project file assignment and retry.")
                prompt.keypress('Press space or enter to continue...', keys: %i[space return])
                execute(function, config, log)
              else
                bar.increment
              end
            end
          end
          puts pastel.green('Digi Carp QC Complete')
          prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
          function = BCDAMS.main_menu
          execute(function, config, log)
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'projectStats'
    MiniExiftool.command = config.fetch(:exifTool)
    database = Pathname.new(config.fetch(:statsDatabase))
    choices = BCDAMS.intro(config.fetch(:projectStats))
    project = BCDAMS.prompt('Compile Project Stats:', choices)
    if project == 'Main Menu'
      function = BCDAMS.main_menu
      execute(function, config, log)
    else
      carp_files = BCDAMS.get_carp_files project, function
      if carp_files.size > 1
        path = prompt.select('Choose a CARP file:', carp_files)
        if path == 'Projects Menu'
          execute(function, config, log)
        else
          carp = BCDAMS.read_carp_file path
          print pastel.yellow('Retrieving Collection ARK ... ')
          collection = carp['collectionTitle']
          if carp['type'] == 'standard'
            ark = Pathname.new(carp['collectionArkUrl']).basename
          else
            ark_uri = BCDAMS.get_ark collection, function, config
            if ark_uri.nil?
              puts pastel.red("Collection ARK Not Found for \'#{collection}\'")
              response = prompt.yes?("Enter alternate Cedar collection title?")
              if response
                reader = TTY::Reader.new
                collection = reader.read_line(">> ").strip
                ark_uri = BCDAMS.get_ark collection, function, config
                if ark_uri.nil?
                  puts pastel.red("Collection ARK Not Found for \'#{collection}\'")
                  prompt.keypress('Press space or enter to continue...', keys: %i[space return])
                  execute(function, config, log)
                end
              else
                execute(function, config, log)
              end
            end
            ark = Pathname.new(ark_uri).basename
          end
          puts pastel.green("Found: #{ark}")
          bar = ProgressBar.create(total: carp['objects'].size, format: 'Getting Object EXIF Metadata: %c/%C |%W| %a')
          objects = []
          carp['objects'].each do |object|
            objects << EXIF.stats(object, project)
            bar.increment
          end
          bar = ProgressBar.create(total: objects.size, format: 'Compiling Project Stats: %c/%C |%W| %a')
          store = YAML::Store.new("#{database}/collections/#{ark}.yml")
          store.transaction do
            if store[ark.to_s].nil?
              store[ark.to_s] = { 'collection' => collection, 'objects' => []}
              store.commit
            end
          end
          objects.each do |object|
            store.transaction do
              store[ark.to_s]['objects'] << object
              store.commit
            end
            bar.increment
          end
          log.info("#{BCDAMS.timestamp} : stats compiled for #{project.basename}")
          puts pastel.green('Stats Compiled')
          prompt.keypress('Press Space or Enter to return to the Main Menu ...', keys: %i[space return])
          function = BCDAMS.main_menu
          execute(function, config, log)
        end
      else
        BCDAMS.no_file 'CARP', function, config
      end
    end

  when 'Quit'
    response = prompt.yes?('Do you really want to quit?')
    if response
      exit
    else
      function = BCDAMS.main_menu
      execute(function, config, log)
    end
  end
end

config = TTY::Config.new

pastel = Pastel.new
print TTY::Box.frame(
  align: :center,
  border: :thick,
  style: {
    border: {
      fg: :red
    }
  }
) { pastel.bold('Digi Workflow Utility') }

workspaces = {
  'Digital Projects' => 'digiProjects',
  'Migration' => 'migration'
}
prompt = TTY::Prompt.new
workspace = prompt.select('Select a Workspace:', workspaces, per_page: 2)

case workspace
when 'digiProjects'
  log = Logger.new 'bcdams-workflow.log'
  config.filename = 'bcdams-paths'
  config.append_path Dir.pwd
  config.read
  function = BCDAMS.main_menu
when 'migration'
  log = Logger.new 'migration-workflow.log'
  config.filename = 'migration-paths'
  config.append_path Dir.pwd
  config.read
  function = BCDAMS.migration_menu
end

log.level = Logger::INFO
execute(function, config, log)
