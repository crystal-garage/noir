require "../theme"

class Noir::Themes::Dracula < Noir::Theme
  name "dracula"

  # Dracula color palette
  # Source: https://github.com/dracula/dracula-theme
  # License: MIT
  palette :background, "#282a36" # Background
  palette :foreground, "#f8f8f2" # Foreground
  palette :selection, "#44475a"  # Selection
  palette :comment, "#6272a4"    # Comment
  palette :cyan, "#8be9fd"       # Cyan
  palette :green, "#50fa7b"      # Green
  palette :orange, "#ffb86c"     # Orange
  palette :pink, "#ff79c6"       # Pink
  palette :purple, "#bd93f9"     # Purple
  palette :red, "#ff5555"        # Red
  palette :yellow, "#f1fa8c"     # Yellow

  style Text, fore: :foreground, back: :background

  style Comment,
    Comment::Multiline,
    Comment::Single, fore: :comment, italic: true
  style Comment::Preproc, fore: :comment, bold: true
  style Comment::Special, fore: :comment, italic: true, bold: true

  style Error, fore: :red, back: :background
  style Generic::Inserted, fore: :green, back: :background
  style Generic::Deleted, fore: :red, back: :background
  style Generic::Emph, fore: :foreground, italic: true
  style Generic::Error, fore: :red, back: :background
  style Generic::Heading, fore: :purple
  style Generic::Output, fore: :selection
  style Generic::Prompt, fore: :comment
  style Generic::Strong, bold: true
  style Generic::Subheading, fore: :purple

  style Keyword,
    Keyword::Constant,
    Keyword::Declaration,
    Keyword::Pseudo,
    Keyword::Reserved,
    Keyword::Type, fore: :pink, bold: true
  style Keyword::Namespace,
    Operator::Word,
    Operator, fore: :pink, bold: true

  style Literal::Number::Float,
    Literal::Number::Hex,
    Literal::Number::Integer::Long,
    Literal::Number::Integer,
    Literal::Number::Oct,
    Literal::Number,
    Literal::String::Escape, fore: :purple

  style Literal::String,
    Literal::String::Char,
    Literal::String::Doc,
    Literal::String::Double,
    Literal::String::Heredoc,
    Literal::String::Interpol,
    Literal::String::Other,
    Literal::String::Regex,
    Literal::String::Single,
    Literal::String::Symbol, fore: :yellow

  style Name::Attribute, fore: :green
  style Name::Class,
    Name::Decorator,
    Name::Exception,
    Name::Function, fore: :green, bold: true
  style Name::Constant, fore: :purple
  style Name::Builtin::Pseudo,
    Name::Builtin,
    Name::Entity,
    Name::Namespace,
    Name::Variable::Class,
    Name::Variable::Global,
    Name::Variable::Instance,
    Name::Variable,
    Text::Whitespace, fore: :foreground
  style Name::Label, fore: :foreground, bold: true
  style Name::Tag, fore: :pink
end
