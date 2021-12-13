require 'csv'
require 'pathname'

parent_data = CSV.read('P:\DigitalProjects\_BCDAMS\2_to_digi\2_to_production\2018_017_shellegram\Production\Shellegram volume info - Sheet1.csv')

path = Pathname.new('P:\DigitalProjects\_BCDAMS\2_to_digi\2_to_production\2018_017_shellegram\Production\Files')
parent_data.each do |line|
  parent = line[1]
  item = path.join(line[0].gsub(' ', '_'))
  item.children.each do |issue|
    File.write(issue.join('metadata.txt'), "parent: #{parent}\n", mode: 'a')
  end
end