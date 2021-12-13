require 'open3'

# status = system("exiftool -v")
# puts status.inspect

stdout, stderr, status = Open3.capture3("puts 'hello'")
# stdout, stderr, status = Open3.capture3('exiftool -v')

puts stdout
puts stderr
puts status
