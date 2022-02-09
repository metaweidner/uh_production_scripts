# Powershell Count PM TIFFs
# Get-ChildItem . -recurse -include *_pm.tif | Measure-Object | %{$_.Count}
# Powershell Count PM TIFFs Within Date Range
# Get-ChildItem . -recurse -include *_pm.tif | Where-Object { $_.CreationTime -ge "09/01/2018" -and $_.CreationTime -le "08/31/2019" } | Measure-Object | %{$_.Count}

require 'pathname'
require 'time'
require 'yaml'
require 'csv'
require 'tty-spinner'
require 'tty-config'
require 'pastel'

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end

def get_images(path, begin_date, end_date, images = {})
  path.children.each do |child|
    if File.directory? child
      dir_name = child.basename.to_s
      unless dir_name == 'Documentation' \
          || dir_name == 'Orphaned' \
          || dir_name == '0_dev' \
          || dir_name == '1_to_carp'
        images = get_images(child, begin_date, end_date, images)
      end
    else
      if child.extname == '.tif' && child.basename.to_s.include?('_pm')
        unless child.basename.to_s.include?('target')
          month = get_time(child, begin_date, end_date)
          images[child] = month unless month.nil?
        end
      end
    end
  end
  images
end

def get_time(image, begin_date, end_date)
  time = File.ctime(image)
  if time > begin_date && time < end_date
    time.month
  else
    nil
  end
end

config = TTY::Config.new
config.filename = 'FY2019_collection_paths'
config.append_path Dir.pwd
config.read

pastel = Pastel.new
begin_date = Time.parse('2018-08-31 23:59:59')
end_date = Time.parse('2019-09-01')

stats = { 'total' => 0,
          2018 => {
            9 => {'count' => 0, 'files' => []},
            10 => {'count' => 0, 'files' => []},
            11 => {'count' => 0, 'files' => []},
            12 => {'count' => 0, 'files' => []}
          },
          2019 => {
            1 => {'count' => 0, 'files' => []},
            2 => {'count' => 0, 'files' => []},
            3 => {'count' => 0, 'files' => []},
            4 => {'count' => 0, 'files' => []},
            5 => {'count' => 0, 'files' => []},
            6 => {'count' => 0, 'files' => []},
            7 => {'count' => 0, 'files' => []},
            8 => {'count' => 0, 'files' => []}
          }
        }
# path = Pathname.new(config.fetch(:bcdams))
# stats_txt = 'FY2019_bcdams_crawl.txt'
path = Pathname.new(config.fetch(:do_production))
stats_txt = 'FY2019_do_production_crawl.txt'

spinner_format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Crawling #{path} ...")
spinner = TTY::Spinner.new(spinner_format, success_mark: pastel.green('+'))
spinner.auto_spin
images = get_images(path, begin_date, end_date)
spinner.success(pastel.green("Found #{images.size} Images"))

spinner_format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Compiling Statistics ...")
spinner = TTY::Spinner.new(spinner_format, success_mark: pastel.green('+'))
spinner.auto_spin
images.each do |path, month|
  stats['total'] += 1
  if month == 9 || month == 10 || month == 11 || month == 12
    stats[2018][month]['count'] += 1
    stats[2018][month]['files'] << path.to_s
  else
    stats[2019][month]['count'] += 1
    stats[2019][month]['files'] << path.to_s
  end
end
File.write(stats_txt, stats.to_yaml)
spinner.success(pastel.green("#{Dir.pwd}/#{stats_txt}"))
