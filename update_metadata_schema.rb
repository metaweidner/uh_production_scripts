require 'pathname'
require 'yaml'
require 'ruby-progressbar'
require 'pastel'
require 'logger'

def nilCheck(field)
  if field.nil?
    value = ''
  else
    value = field.to_s.strip
  end
  value.gsub("\"","\'")
end

def get_metadata(path, metadata = [])
  path.children.each do |child|
    if File.directory? child
      get_metadata child, metadata
    else
      if child.basename.to_s == 'metadata.txt'
        metadata << child
        print "Gathering metadata.txt files: #{metadata.size}\r"
        $stdout.flush
      end
    end
  end
  metadata
end

pastel = Pastel.new
dir = 'P:\DigitalProjects\_TDD\5_to_ingest'
# dir = 'P:\DigitalProjects\_TDD\4_to_metadata'
# dir = 'P:\DigitalProjects\_TDD\3_to_ocr'
# dir = 'P:\DigitalProjects\_TDD\2_to_digitization'
# dir = 'P:\DigitalProjects\_TDD\1_batch_prep\1_tdd-pre-1978'
puts pastel.yellow("Updating #{dir}")

metadata = get_metadata(Pathname.new(dir))
puts pastel.green("Found #{metadata.size} Metadata Files                         ")
bar = ProgressBar.create(total: metadata.size, format: 'Writing New Metadata: %c/%C |%W| %a')
log = Logger.new File.open('update_metadata_schema.log', 'w')
log.level = Logger::INFO
errors = []
metadata.each do |path|
  begin
    meta = YAML.load_file(path)
  rescue StandardError => e
    log.error "Error - #{e}"
    errors << path
    next
  end
  if meta.key?('dc.format.digitalorigin')
    origin = nilCheck(meta['dc.format.digitalorigin'])
  else
    origin = nilCheck(meta['dc.format.digitalOrigin'])
  end
  new_meta = {
    'dc.identifier.other' => nilCheck(meta['dc.identifier.other']),
    'dc.contributor.advisor' => '',
    'dc.contributor.committeeMember' => '',
    'dc.creator' => nilCheck(meta['dc.creator']),
    'dc.title' => nilCheck(meta['dc.title']),
    'dc.date.issued' => nilCheck(meta['dc.date.issued']),
    'dc.description.department' => nilCheck(meta['dc.description.department']),
    'thesis.degree.discipline' => nilCheck(meta['thesis.degree.discipline']),
    'thesis.degree.college' => nilCheck(meta['thesis.degree.college']),
    'thesis.degree.department' => nilCheck(meta['thesis.degree.department']),
    'thesis.degree.name' => nilCheck(meta['thesis.degree.name']),
    'thesis.degree.level' => nilCheck(meta['thesis.degree.level']),
    'dc.language.iso' => nilCheck(meta['dc.language.iso']),
    'dc.relation.ispartof' => nilCheck(meta['dc.relation.ispartof']),
    'dc.subject' => nilCheck(meta['dc.subject']),
    'dc.type.dcmi' => nilCheck(meta['dc.type.dcmi']),
    'dc.format.mimetype' => nilCheck(meta['dc.format.mimetype']),
    'thesis.degree.grantor' => nilCheck(meta['thesis.degree.grantor']),
    'dc.format.digitalOrigin' => origin,
    'dc.type.genre' => nilCheck(meta['dc.type.genre']),
    'dc.description.abstract' => nilCheck(meta['dc.description.abstract']),
    'dc.rights' => nilCheck(meta['dc.rights']),
    'Pages' => nilCheck(meta['Pages']),
    'DigiBatch' => nilCheck(meta['DigiBatch']),
    'DateDigitized' => nilCheck(meta['DateDigitized']),
    'DigiNote' => nilCheck(meta['DigiNote']),
    'MetaNote' => nilCheck(meta['MetaNote']),
    'RightsNote' => nilCheck(meta['RightsNote'])
  }
  File.open(path, "w") {|f| f.write(new_meta.to_yaml)}
  bar.increment
end
puts pastel.green("Metadata Update Complete: #{dir}")
puts "Found the following errors: #{errors}" unless errors == []
