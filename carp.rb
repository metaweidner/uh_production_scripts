# frozen_string_literal: true

module Carp
  module_function

  class Collection
    attr_reader :type, :title, :ark, :size, :objects

    def initialize(carp, app_data)
      @type = carp['type']
      @title = carp['collectionTitle']
      case @type
      when 'standard'
        @ark = carp['collectionArkUrl']
      when 'findingaid'
        @ark = self.get_ark(@title, app_data['function'], app_data['config'], app_data['log'])
        if @ark.nil?
          pastel = Pastel.new
          puts pastel.red("Collection ARK Not Found for \'#{@title}\'")
          prompt = TTY::Prompt.new
          response = prompt.yes?("Enter Cedar Collection ARK?")
          if response
            reader = TTY::Reader.new
            @ark = reader.read_line(">> ").strip
          else
            execute(app_data['function'], app_data['config'], app_data['log'])
          end
        end
      end
      @size = 0
      @objects = self.get_objects(carp['objects'])
      @objects.each {|object| @size += object.size}
    end

    def get_ark(collection, function, config, log)
      match_query = RDF::Query.new(
        match: { RDF::URI('http://sindice.com/vocab/search#totalResults') => :result }
      )
      link_query = RDF::Query.new(
        link: { RDF::URI('http://sindice.com/vocab/search#link') => :uri }
      )
      id_query = RDF::Query.new(
        id: { RDF::URI('http://www.w3.org/2004/02/skos/core#exactMatch') => :ark }
      )

      search = URI.escape("https://vocab.lib.uh.edu/search.ttl?depth=5&l=en&for=concept&q=#{collection}&qt=exact&t=labels")
      search.gsub!("a\%CC\%81", "\%C3\%A1")
      search.gsub!("e\%CC\%81", "\%C3\%A9")
      search.gsub!("i\%CC\%81", "\%C3\%AD")
      search.gsub!("o\%CC\%81", "\%C3\%B3")
      search.gsub!("u\%CC\%81", "\%C3\%BA")
      begin
        graph = RDF::Graph.load(search.to_s)
      rescue StandardError
        puts "ERROR: Cedar 501 for \'#{collection}\'"
        log.error"#{BCDAMS.timestamp} : Cedar 501 for \'#{collection}\' : #{search}"
        execute function, config, log
      end

      results = match_query.execute(graph)
      if results.first[:result].to_i == 1
        link = link_query.execute(graph)
        id = id_query.execute(RDF::Graph.load("#{link.first[:uri]}.ttl"))
        ark = id.first[:ark]
      else
        ark = nil
      end
      ark
    end

    def get_objects(carp_objects)
      project_objects = []
      carp_objects.each do |object|
        project_objects << DigitalObject.new(object)
      end
      project_objects
    end

  end

  class DigitalObject
    attr_reader :title, :images, :docs, :size

    def initialize(carp_object)
      @title = carp_object['title']
      @size = 0
      @images = []
      @docs = []
      carp_object['files'].each do |file|
        if file['path'].include? '.tif'
          @images << Pathname.new(file['path'])
          @size += 1
        else
          @docs << file
        end
      end
    end
  end

  def files(project, function)
    carp_files = {}
    carp_files[".. (#{function} Projects Menu)"] = 'Projects Menu'
    project.each_child do |child|
      carp_files[child.basename] = child if child.extname == '.carp'
    end
    carp_files
  end

  def read(path)
    file = File.read(path)
    carp = JSON.parse(file)
    carp
  end

end