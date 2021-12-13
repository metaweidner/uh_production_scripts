require 'json'
require 'pathname'
require 'fileutils'
require 'mini_exiftool'
MiniExiftool.command = "./exiftool.exe"

file = File.read(ARGV[0])
carp = JSON.parse(file)

carp['objects'].each do |object|
  id = object['do_ark']
  puts "\n" + id
  object['files'].each do |file|
    path = file['path']
    if path.include? "_ac"
      file_name = path.split("\\")[-1]
      puts file_name
      image = MiniExiftool.new path
      image.identifier = id
      image.title = file_name
      image.save
    end
  end
end


