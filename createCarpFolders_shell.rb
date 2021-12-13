require 'csv'
require 'fileutils'

shotlist = CSV.read("#{ARGV[0]}", headers: true)

shotlist.each do |row|
  folder = row['Location']
  title = row['Title']
  FileUtils.mkdir_p "Files/#{folder}/ac"
  FileUtils.mkdir_p "Files/#{folder}/pm"
  File.write("Files/#{folder}/metadata.txt", "title: #{title}\nlocation: #{folder}\nnote:")
end
