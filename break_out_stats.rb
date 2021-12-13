require 'yaml'
require 'yaml/store'

store = YAML::Store.new('P:\DigitalProjects\_BCDAMS\0_dev\stats\bcdams_stats.yaml')

store.transaction(true) do
  store.roots.each do |ark|
    puts "Processing #{ark}"
    new_store = YAML::Store.new("P:/DigitalProjects/_BCDAMS/0_dev/stats/#{ark}.yaml")
    objects = store[ark]
    new_store.transaction do
      new_store[ark] = { 'collection' => '', 'objects' => objects }
      store.commit
    end
  end
end
