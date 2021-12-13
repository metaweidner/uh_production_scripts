require 'csv'
require 'pathname'
require 'fileutils'

production = Pathname.new('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\4305754_texaco_pre-1964\Production\pm_jpeg_comp')
FileUtils.mkdir_p production
pm_files = CSV.read('P:\DigitalProjects\_BCDAMS\2_to_digi\3_to_post-process\4305754_texaco_pre-1964\Documentation\4305754_texaco_pre-1964_qc_preservation_jpegcomp_20191218.csv', headers: true)

pm_files.each do |line|
  directory = Pathname.new(line['Directory'])
  origin = directory.join(line['File Name'])
  destination = production.join(line['File Name'])
  FileUtils.cp(origin, destination)
end
