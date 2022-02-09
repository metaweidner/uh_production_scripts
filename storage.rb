def write path, content = ''
  File.open(path, 'w') do |f|
    f.print content
    f.close
  end
end

def append path, content = ''
  File.open(path, 'a') do |f|
    f.print content
    f.close
  end
end

class Service

  attr_reader :name,
              :one_time_fee,
              :annual_fee,
              :free_tb,
              :ingest_per_tb,
              :storage_per_tb
  attr_accessor :stored_tb, :total_cost, :costs

  def initialize service
    @name = service['service_name']
    @one_time_fee = service['one_time_fee']
    @annual_fee = service['annual_fee']
    @free_tb = service['free_tb']
    @ingest_per_tb = service['ingest_per_tb']
    @storage_per_tb = service['storage_per_tb']    
    @stored_tb = 0
    @total_cost = 0
    @costs = Array.new
  end

  def get_cost growth
    growth.each_with_index do |number_of_tb, i|
      cost = 0
      self.stored_tb += number_of_tb 
      if self.name == 'DPN'
        cost = number_of_tb * self.storage_per_tb
        self.costs << cost      
      else
        ingest_cost = (number_of_tb - self.free_tb) * self.ingest_per_tb
        storage_cost = (self.stored_tb - self.free_tb) * self.storage_per_tb
        cost += self.one_time_fee if i == 0
        cost += self.annual_fee + ingest_cost + storage_cost
        self.costs << cost
      end
      self.total_cost += cost
    end
  end
end

services = [
            { 'service_name' => 'Glacier',
              'one_time_fee' => 1000,
              'annual_fee' => 2500,
              'free_tb' => 2,
              'ingest_per_tb' => 0,
              'storage_per_tb' => 50 },
            { 'service_name' => 'S3',
              'one_time_fee' => 1000,
              'annual_fee' => 2500,
              'free_tb' => 2,
              'ingest_per_tb' => 0,
              'storage_per_tb' => 285 },
            { 'service_name' => 'Chronopolis',
              'one_time_fee' => 1000,
              'annual_fee' => 2500,
              'free_tb' => 2,
              'ingest_per_tb' => 120,
              'storage_per_tb' => 165 },
            { 'service_name' => 'DPN',
              'one_time_fee' => 0,
              'annual_fee' => 0,
              'free_tb' => 0,
              'ingest_per_tb' => 0,
              'storage_per_tb' => 2750 }
          ]

# growth = [25, 35, 25]
# growth = [25, 35, 25, 20, 20]
# growth = [25, 35, 25, 20, 20, 15, 15, 15, 15, 15]
growth = [25, 35, 25, 20, 20, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15]
providers = Hash.new
@table = Array.new
@path = 'C:\Users\weidnera\Documents\storage_cost.tsv'

services.each do |service|
  provider = Service.new service
  provider.get_cost(growth)
  provider.costs << provider.total_cost
  providers[provider.name] = provider.costs
end

write @path, "Year @ Growth\t"
providers.each do |provider, data|
  append @path, "#{provider}\t"
end
append @path, "\n"

providers.each do |provider, data|
  i = 1
  row = Hash.new
  data.each do |cost|
    row[i] = cost
    i += 1
  end
  @table << row
end

growth.each_with_index do |number_of_tb, i|
  year = i + 1
  append @path, "#{year} @ #{number_of_tb}TB\t"
  @table.each do |data|
    append @path, "#{data[year]}\t"
  end
  append @path, "\n"
end

append @path, "Total Cost\t"
providers.each do |service, data|
  append @path, "#{data.last}\t"
end