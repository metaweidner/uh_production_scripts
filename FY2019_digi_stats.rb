# Powershell Count PM TIFFs
# Get-ChildItem . -recurse -include *_pm.tif | Measure-Object | %{$_.Count}
# Powershell Count PM TIFFs Within Date Range
# Get-ChildItem . -recurse -include *_pm.tif | Where-Object { $_.CreationTime -ge "09/01/2018" -and $_.CreationTime -le "08/31/2019" } | Measure-Object | %{$_.Count}

require 'pathname'
require 'time'
require 'yaml'
require 'csv'
require 'tty-spinner'
require 'pastel'

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end

def get_images(path, images = [])
  path.children.each do |child|
    if File.directory? child
      dir_name = child.basename.to_s
      unless dir_name == 'Documentation' || dir_name == 'Orphaned'
        get_images child, images
      end
    else
      if child.extname == '.tif' && child.basename.to_s.include?('_pm')
        images << child unless child.basename.to_s.include?('target')
      end
    end
  end
  images    
end

# config = TTY::Config.new
# config.filename = 'FY2019_collection_paths'
# config.append_path Dir.pwd
# config.read

pastel = Pastel.new
begin_date = Time.parse('2018-08-31 23:59:59')
end_date = Time.parse('2019-09-01')

stats = { 'total' => 0,
          2018 => {
            9 => 0,
            10 => 0,
            11 => 0,
            12 => 0
          },
          2019 => {
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0
          },
          'collections' => {}
        }
projects = YAML.load(File.read("#{Dir.pwd}/FY2019_collection_paths.yml"))
spreadsheet = [['COLLECTION','2018-09','2018-10','2018-11','2018-12','2019-01','2019-02','2019-03','2019-04','2019-05','2019-06','2019-07','2019-08','TOTAL']]
total_row = ['TOTAL',0,0,0,0,0,0,0,0,0,0,0,0]
partial = {}
projects.each do |collection, location|
  spinner_format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Getting \'#{collection}\' Images ...")
  spinner = TTY::Spinner.new(spinner_format, success_mark: pastel.green('+'))
  spinner.auto_spin
  path = Pathname.new(location)
  images = get_images(path)
  spinner.success(pastel.green("Found #{images.size} Collection Images"))
  spinner_format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Compiling \'#{collection}\' Stats ...")
  spinner = TTY::Spinner.new(spinner_format, success_mark: pastel.green('+'))
  spinner.auto_spin
  row = [collection,0,0,0,0,0,0,0,0,0,0,0,0]
  count = 0
  images.each do |image|
    time = File.ctime(image)
    if time > begin_date && time < end_date
      count += 1
      stats[time.year][time.month] += 1
      case time.month
      when 9
        row[1] += 1
        total_row[1] += 1
      when 10
        row[2] += 1        
        total_row[2] += 1
      when 11
        row[3] += 1
        total_row[3] += 1
      when 12
        row[4] += 1
        total_row[4] += 1
      when 1
        row[5] += 1
        total_row[5] += 1
      when 2
        row[6] += 1
        total_row[6] += 1
      when 3
        row[7] += 1
        total_row[7] += 1
      when 4
        row[8] += 1
        total_row[8] += 1
      when 5
        row[9] += 1
        total_row[9] += 1
      when 6
        row[10] += 1
        total_row[10] += 1
      when 7
        row[11] += 1
        total_row[11] += 1
      when 8
        row[12] += 1
        total_row[12] += 1
      end
    end
  end
  row << count
  spreadsheet << row
  stats['collections'][collection] = count
  stats['total'] += count
  percent = '%.2f' % count.percent_of(images.size)
  if percent.to_f < 100.00
    partial[collection] = percent
  end
  spinner.success(pastel.green("#{count} Stats Images (#{percent}%)"))
end
stats_txt = 'FY2019_digi_stats.txt'
stats_csv = 'FY2019_digi_stats.csv'
stats['collections'] = stats['collections'].sort_by { |k,v| v }.to_h
File.write(stats_txt, stats.to_yaml)
CSV.open(stats_csv, 'w') do |csv|
  spreadsheet.each { |row| csv << row }
  total_row << stats['total']
  csv << total_row
end
puts "Partial Collections:"
partial.each do |collection, percent|
  puts " -- #{collection}: #{percent}%"
end
puts "Stats Files:"
puts " -- #{Dir.pwd}/#{stats_txt}"
puts " -- #{Dir.pwd}/#{stats_csv}"
