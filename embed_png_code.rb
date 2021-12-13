html = File.open("#{volume}/#{volume.basename}.htm") { |f| Nokogiri::HTML(f) }
head = html.css('head')
head[0].add_child("<title>#{metadata['dc.title']}</title>")
head[0].add_child("<meta name=\'author\' content=\'#{metadata['dc.creator']}\'>")
unless metadata['dc.subject'] == ''
  head[0].add_child("<meta name=\'keywords\' content=\'#{metadata['dc.subject'].gsub('||',',')}\'>")
end
img = html.css('img')
unless img == []
  img.each do |tag|
    image = tag['src']
    tag['alt'] = image
    code = image.gsub('.png','.txt')
    system("certutil -encode #{volume}/#{image} #{volume}/#{code} > nul")
    # if $? == 0
    #   puts "#{code} added"
    # else
    #   puts "#{code}  failed"
    # end
    embed = File.read("#{volume}/#{code}")
    embed = embed.gsub("-----BEGIN CERTIFICATE-----","")
    embed = embed.gsub("-----END CERTIFICATE-----","")
    embed = embed.strip
    tag['src'] = "data:image/png;base64,#{embed}"
    File.delete("#{volume}/#{code}")
    File.delete("#{volume}/#{image}")
  end
end
File.write("#{volume}/#{volume.basename}.htm", html.to_html)
