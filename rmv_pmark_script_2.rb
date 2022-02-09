require 'json'

CARP_FILE = ARGV[0]

file = File.read(CARP_FILE)
carp = JSON.parse(file)

# puts carp['objects'][3]['uuid']
# puts carp['objects'][3]['files'][2]['path']
# puts carp['objects'][3]['files'][2]['purpose']

carp['objects'].each_with_index do |object, index|
  # object['pm_ark'] = ""
  puts "Object: #{index}"
  puts object['pm_ark']
  # object['metadata']['dcterms.source'] = ""
  puts object['metadata']['dcterms.source']
end

t = Time.now.strftime("%Y%m%d_%H%M")
carp_file = File.write("#{t}_#{CARP_FILE}", carp.to_json)