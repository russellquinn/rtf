begin
  require 'loofah'
rescue LoadError
  puts "Loofah is required to convert HTML. Please run `gem install loofah'"
end

module RTF
  module Converters
    class HTML

      def initialize(html, options = {})
        options = { clean: true }.merge(options)
        @html = Loofah.fragment(html)
        @html.scrub!(:strip) if options[:clean]
      end

      def to_rtf_document(options = {})
        font  = Mapping::HTML.font(options[:font] || :default)

        RTF::Document.new(font).tap do |rtf|
          Mapping::HTML.to_rtf(@html.children, rtf)
        end
      end

      def to_rtf(options = {})
        to_rtf_document(options).to_rtf
      end
    end

    module Mapping
      module HTML
        extend self

        def font(key)
          fonts = {
            default:   [:roman,  'Times New Roman'],
            monospace: [:modern, 'Courier New']
          }
          
          RTF::Font.new(*fonts[key])
        end

        def style(key)
          sizes = { h1: 44, h2: 36, h3: 28, h4: 22 }

          RTF::CharacterStyle.new.tap do |style|
            style.font_size = sizes[key.to_sym]
            style.bold = true
          end
        end

        def to_rtf(node, rtf)
          if !node.respond_to? :name
            node.each { |n| to_rtf(n, rtf) }
            return rtf
          end

          case node.name
          when 'text'                   then rtf << node.text
          when 'br'                     then rtf.line_break
          when 'b', 'strong'            then rtf.bold &recurse(node.children)
          when 'i', 'em', 'cite'        then rtf.italic &recurse(node.children)
          when 'u'                      then rtf.underline &recurse(node.children)
          when 'blockquote', 'p', 'div' then rtf.paragraph &recurse(node.children)
          when 'span'                   then to_rtf(node.children, rtf)
          when 'sup'                    then rtf.subscript &recurse(node.children)
          when 'sub'                    then rtf.superscript &recurse(node.children)
          when 'ul'                     then rtf.list :bullets, &recurse(node.children)
          when 'ol'                     then rtf.list :decimal, &recurse(node.children)
          when 'li'                     then rtf.item &recurse(node.children)
          when 'a'                      then rtf.link node[:href], &recurse(node.children)
          when 'h1', 'h2', 'h3', 'h4'   then rtf.apply(style(node.name), &recurse(node.children)); rtf.line_break
          when 'code'                   then rtf.font font(:monospace), &recurse(node.children)
          else
            # Unknown node type
          end

          rtf
        end

        def recurse(node)
          lambda { |rtf| to_rtf(node, rtf) }
        end
      end
    end      
  end
end
