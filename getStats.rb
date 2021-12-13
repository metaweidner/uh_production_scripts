require 'yaml'

database = YAML.load_file('tdd_metadata.yaml')
total_pages = 0
database.each do |id, data|
  metadata = data['metadata']
  puts id + ": " + metadata['Pages'].to_s
  puts metadata['DigiNote']
  total_pages += metadata['Pages']
end
puts "Total Pages: #{total_pages}"