require 'csv'
require 'json'
require 'fileutils'

# ==============================================================
# parse csv
# ==============================================================
tdd = CSV.read('TDD Metadata Mapping - Test page 20190904.csv', headers: true)
records = {}

tdd.each do |record|
  oclc = record['dc.identifier.other'].strip
  date = record['dc.date.issued'].to_s.strip
  author = record['dc.creator'].strip
  title = record['dc.title'].strip
  degree = record['thesis.degree.name'].strip
  department = record['dc.description.department'].strip
  lcc = record['dc.identifier.lcc'].strip
  if record['dc.subject'].nil?
    subject = ''
  else
    subject = record['dc.subject'].strip
  end
  type = record['dc.type.material'].strip
  mimetype = record['dc.format.mimetype'].strip
  institution = record['thesis.degree.grantor'].strip
  records[oclc] = {'author' => author,
                   'title' => title,
                   'date' => date,
                   'degree' => degree,
                   'department' => department,
                   'lcc' => lcc,
                   'subject' => subject,
                   'type' => type,
                   'mimetype' => mimetype,
                   'institution' => institution}
end
File.open('tdd-pilot-20190904.json', 'w') {|f| f.write(records.to_json)}


# ==============================================================
# parse json
# ==============================================================
def create_object_folder(dir, id, record)
  date = record['date']
  dir = dir + "/#{date}/#{id}"
  FileUtils.mkdir_p dir
  metadata = create_metadata(id, record)
  File.open("#{dir}/metadata.txt", "w") {|f| f.write(metadata)}
end 

def create_metadata(id, record)
  author = record['author']
  title = record['title']
  date = record['date']
  degree = record['degree']
  department = record['department']
  lcc = record['lcc']
  subject = record['subject']
  type = record['type']
  mimetype = record['mimetype']
  institution = record['institution']
  metadata = "oclc: #{id}\n"\
             "author: #{author}\n"\
             "title: #{title}\n"\
             "date: #{date}\n"\
             "degree: #{degree}\n"\
             "department: #{department}\n"\
             "lcc: #{lcc}\n"\
             "subject: #{subject}\n"\
             "type: #{type}\n"\
             "mimetype: #{mimetype}\n"\
             "institution: #{institution}\n"\
             "note:\n"
  # metadata = "oclc: #{id}\n"\
  #            "author: #{author}\n"\
  #            "title: #{title}\n"\
  #            "date: #{date}\n"\
  #            "degree: #{degree}\n"\
  #            "department: #{department}\n"\
  #            "lcc: #{lcc}\n"\
  #            "subject: #{subject}\n"\
  #            "type: #{type}\n"\
  #            "mimetype: #{mimetype}\n"\
  #            "institution: #{institution}\n"\
  #            "note:\n"
end

file = File.read('tdd-pilot-20190904.json')
tdd = JSON.parse(file)
tdd.each do |id,record|
  puts id
  if record['date'].include? '194'
    dir = 'tdd-pilot-20190904/1940s'
  elsif record['date'].include? '195'
    dir = 'tdd-pilot-20190904/1950s'    
  elsif record['date'].include? '196'
    dir = 'tdd-pilot-20190904/1960s'
  elsif record['date'].include? '197'
    dir = 'tdd-pilot-20190904/1970s'
  elsif record['date'].include? '198'
    dir = 'tdd-pilot-20190904/1980s'
  elsif record['date'].include? '199'
    dir = 'tdd-pilot-20190904/1990s'
  elsif record['date'].include? '200'
    dir = 'tdd-pilot-20190904/2000s'
  elsif record['date'].include? '201'
    dir = 'tdd-pilot-20190904/2010s'
  else
    dir = 'tdd-pilot-20190904/unknown'
  end
  create_object_folder(dir, id, record)
end

