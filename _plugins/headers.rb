require 'redcarpet'
require 'rexml/document'
module Redcarpet::Render
  class Custom < Base
    def header(title, level)
      @headers ||= []

      title_elements = REXML::Document.new(title)
      flattened_title = title_elements.inject('') do |flattened, element|
        flattened +=  if element.respond_to?(:text)
                        element.text
                      else
                        element.to_s
                      end
      end
      permalink = flattened_title.downcase.gsub(/[^a-z\s]/, '').gsub(/\W+/, "-")
      
      #TODO : implement this as its own method
      if @headers.include?(permalink)
        permalink += "_1"
        
        loop do
          break if !@headers.include?(permalink)
          # generate titles like foo-bar_1, foo-bar_2
          permalink.gsub!(/\_(\d+)$/, "_#{$1.to_i + 1}")
        end
      end
      @headers << permalink
      %(\n<h#{level}><a name="#{permalink}" class="anchor" href="##{permalink}"><span class="anchor-icon"></span></a>#{title}</h#{level}>\n)
    end
  end
end

# gh = Redcarpet::Render::GithubStyleTitles.new
# puts Redcarpet::Markdown.new(gh).render "test\n\n# test 1\n\n# test 2\n\n# test 1\n\n# test 1"