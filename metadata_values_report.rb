require 'csv'
require 'yaml'
require 'pathname'

metadata_path = 'P:/DigitalProjects/_TDD/4_to_metadata'
metadata_files = Dir.glob("#{metadata_path}/**/*_metadata.txt")
time = Time.now.strftime("%Y%m%d-%H%M")
headers = %w[Directory OCLC thesis.degree.college dc.date.issued thesis.degree.department dc.description.department]

CSV.open("#{metadata_path}/0_Documentation/thesis-degree-college_#{time}.csv", 'w') do |csv|
  csv << headers
  metadata_files.each do |path|
    parent = Pathname.new(path).parent.parent
    directory, oclc = parent.split
    row = [directory, oclc]
    begin
      metadata = YAML.load_file(path)
    rescue StandardError => e
      puts "#{e}"
      next
    end
    row << metadata['thesis.degree.college']
    row << metadata['dc.date.issued']
    row << metadata['thesis.degree.department']
    row << metadata['dc.description.department']
    csv << row
  end
end

