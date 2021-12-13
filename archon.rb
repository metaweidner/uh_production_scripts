require 'eadsax'
require 'htmlentities'

ead = Eadsax::Ead.parse(File.read('./quintero.xml'))
coder = HTMLEntities.new
# puts ead.inspect

ead.archdesc.dsc.c01s.each do |c01|
  puts c01.c02s[1].inspect
  # puts c01.level + ": " + c01.did.unittitle
  # c01.c02s.each do |c02|
  #   puts "   " + c02.level + ": " + c02.did.unittitle
  #   c02.c03s.each do |c03|
  #     puts "      " + c03.level + ": " + c03.did.unittitle
  #     c03.c04s.each do |c04|
  #       puts "         " + c04.level + ": " + c04.did.unittitle
  #     end
  #   end
  # end
end