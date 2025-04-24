require "../lexer"

class Noir::Lexers::XML < Noir::Lexer
  tag "xml"
  aliases %w(xml)
  filenames %w(*.xml *.xsl *.rss *.xslt *.xsd *.wsdl *.svg)
  mimetypes %w(
    application/xml application/xml-dtd
    application/xslt+xml application/xhtml+xml
    application/atom+xml application/mathml+xml
    application/rss+xml application/svg+xml
  )

  state :root do
    rule /[^<&]+/, Text
    rule /&\S*?;/, Name::Entity
    rule /<!DOCTYPE .*?>/im, Comment::Preproc
    rule /<!\[CDATA\[.*?\]\]>/m, Comment::Preproc
    rule /<!--/, Comment, :comment
    rule /<\?.*?\?>/m, Comment::Preproc

    rule /<\//, Name::Tag, :tag_end
    rule /</, Name::Tag, :tag_start

    rule %r(<\s*[a-zA-Z0-9_:-]+), Name::Tag, :tag   # opening tags
    rule %r(<\s*/\s*[a-zA-Z0-9_:-]+\s*>), Name::Tag # closing tags
  end

  state :tag_end do
    mixin :tag_end_end
    rule /[a-zA-Z0-9_:-]+/ do |m|
      m.token Name::Tag
      m.goto :tag_end_end
    end
  end

  state :tag_end_end do
    rule /\s+/, Text
    rule />/, Name::Tag, :pop!
  end

  state :tag_start do
    rule /\s+/, Text

    rule /[a-zA-Z0-9_:-]+/ do |m|
      m.token Name::Tag
      m.goto :tag
    end

    rule(//) { |m| m.goto :tag }
  end

  state :comment do
    rule /[^-]+/, Comment
    rule /-->/, Comment, :pop!
    rule /-/, Comment
  end

  state :tag do
    rule /\s+/, Text
    rule /[a-zA-Z0-9_:-]+\s*=\s*/, Name::Attribute, :attr
    rule /[a-zA-Z0-9_:-]+/, Name::Attribute
    rule %r(/?\s*>), Name::Tag, :pop!
  end

  state :attr do
    rule /"/ do |m|
      m.token Str
      m.goto :dq
    end

    rule /'/ do |m|
      m.token Str
      m.goto :sq
    end

    rule /[^\s>]+/, Str, :pop!
  end

  state :dq do
    rule /"/, Str, :pop!
    rule /[^"]+/, Str
  end

  state :sq do
    rule /'/, Str, :pop!
    rule /[^']+/, Str
  end
end
