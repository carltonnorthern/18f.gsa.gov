# Create a custom renderer that extend Redcarpet to customize its behavior.
#require 'jekyll'
require 'redcarpet'
require 'rexml/document'
module Jekyll
class RedcarpetExtender < Redcarpet::Render::HTML
  # Extend the table to be compatible with the Bootstrap css.
#   def header(title, level)
  
#      @headers ||= []

#       title_elements = REXML::Document.new(title)
#       flattened_title = title_elements.inject('') do |flattened, element|
#         flattened +=  if element.respond_to?(:text)
#                         element.text
#                       else
#                         element.to_s
#                       end
#       end
#       id_name = flattened_title.downcase.gsub(/[^a-z\s]/, '').gsub(/\W+/, "-")
      
#       #TODO : implement this as its own method
#       if @headers.include?(id_name)
#         id_name += "_1"
        
#         loop do
#           break if !@headers.include?(id_name)
#           # generate titles like foo-bar_1, foo-bar_2
#           id_name.gsub!(/\_(\d+)$/, "_#{$1.to_i + 1}")
#         end
#       end
#       @headers << id_name
    
#       #<h2 id="someheader">someheader</h2>
#       %(\n<h#{level} id="#{id_name}">#{title}</h#{level}>\n)
#     end
end

class Jekyll::Converters::Markdown::RedcarpetExt
  def initialize(config)
    @site_config = config
  end

  def extensions
    Hash[ *@site_config['redcarpet']['extensions'].map {|e| [e.to_sym, true]}.flatten ]
  end
  
  def markdown
    puts extensions
    @markdown ||= Redcarpet::Markdown.new(RedcarpetExtender, extensions)
  end

  def convert(content)
    return super unless @site_config['markdown'] == 'RedcarpetExt'
    markdown.render(content)
  end
end
end