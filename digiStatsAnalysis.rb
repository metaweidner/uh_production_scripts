require 'csv'

pm = CSV.read('PM_revised.txt', col_sep: "\t")
ac = CSV.read('AC_revised.txt', col_sep: "\t")
pm_files = []
ac_files = []

pm.each do |file|
  pm_files << file[1][0...-7]
end
ac.each do |file|
  ac_files << file[1][0...-7]
end

pm_only = pm_files - ac_files
ac_only = ac_files - pm_files

File.open('PM_only.txt', 'w') do |f|
  f.puts(pm_only)
end
File.open('AC_only.txt', 'w') do |f|
  f.puts(ac_only)
end
