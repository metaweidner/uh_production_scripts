require 'csv'
require 'pathname'
require 'fileutils'
require 'mini_exiftool'
require 'ruby-progressbar'

production = Pathname.new('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\4305754_texaco_pre-1964\Production\pm_jpeg_comp\Converted')
pm_files = CSV.read('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\4305754_texaco_pre-1964\Documentation\4305754_texaco_pre-1964_qc_preservation_jpegcomp_20191218.csv', headers: true)
bar = ProgressBar.create(total: pm_files.size, format: "Copying Files: %c/%C |%W| %a")

pm_files.each do |line|
  directory = Pathname.new(line['Directory'])
  origin = production.join(line['File Name'])
  destination = directory.join(line['File Name'])
  MiniExiftool.command = 'P:\DigitalProjects\_BCDAMS\0_dev\workflow\exiftool.exe'
  exif = MiniExiftool.new destination.to_s
  image = MiniExiftool.new origin.to_s
  image.date_time_original = nil
  image.create_date = exif.file_modify_date
  image.creator = 'University of Houston Libraries'
  image.save
  FileUtils.cp_r(origin, destination, remove_destination: true)
  bar.increment
end
