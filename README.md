# NOIR

Syntax Highlight Library for [Crystal](https://crystal-lang.org)

## Usage

Add to your `shard.yml`:
```yaml
dependencies:
  noir:
    github: MakeNowJust/noir
```

Basic usage:
```crystal
require "noir"

# Get a lexer by language name
lexer = Noir.find_lexer("xml")

# Choose a formatter (HTML, HTML-inline, or Terminal-RGB)
formatter = Noir::Formatters::HTML.new(io)

# Highlight the code
Noir.highlight(code, lexer: lexer, formatter: formatter)
```

Using with custom theme:
```crystal
# Get a theme by name
theme = Noir.find_theme("monokai")

# Create HTML formatter with inline styles
formatter = Noir::Formatters::HTMLInline.new(theme, io)

# Highlight with custom theme
Noir.highlight(code, lexer: lexer, formatter: formatter)
```

Terminal output:
```crystal
# Use Terminal-RGB formatter for colored console output
formatter = Noir::Formatters::TerminalRGB.new(theme, io)
Noir.highlight(code, lexer: lexer, formatter: formatter)
```

## Supported Languages

NOIR supports syntax highlighting for the following languages:

- Crystal (`.cr`)
- CSS (`.css`)
- Elm (`.elm`)
- HTML (`.html`, `.htm`, `.xhtml`)
- JavaScript (`.js`)
- JSON (`.json`)
- Python (`.py`, `.pyw`)
- Ruby (`.rb`, `.ruby`, `.rbw`, `.rake`, `.gemspec`)
- SQL (`.sql`)
- XML (`.xml`, `.xsl`, `.rss`, `.xslt`, `.xsd`, `.wsdl`, `.svg`)

## Supported Themes

NOIR comes with the following themes:

- Dracula - Dark theme with vibrant colors
- Monokai - Dark theme with bright colors
- Solarized - Light and dark variants available

## CLI

[ET NOIR](etnoir/) is CLI tool for NOIR. It can be installed with these commands:

```console
$ git clone https://github.com/MakeNowJust/noir
$ cd noir
$ make
```

Then `bin/etnoir` is available:

```console
$ bin/etnoir
ET NOIR - NOIR command-line tool

Usage:
    etnoir highlight FILENAME
    etnoir style THEME

Command:
    highlight                        highlight FILENAME content
    style                            print THEME style as CSS
    help                            show this help
    version                         show ET NOIR version
```

## Development

### Adding a New Lexer

1. Create a new lexer file in `src/noir/lexers/`:
   ```crystal
   require "../lexer"

   class Noir::Lexers::YourLexer < Noir::Lexer
     tag "yourlang"                    # Language tag
     aliases %w(yl)                    # Optional aliases
     filenames %w(*.yl *.yourlang)     # File extensions
     mimetypes %w(text/x-yourlang)     # MIME types

     state :root do
       # Define your lexer rules here
     end
   end
   ```

2. Add your lexer to `etnoir/src/etnoir/lexers.cr`

3. Create specs in `spec/lexers/yourlang/`:
   - Create test fixtures in `spec/lexers/yourlang/fixtures/`
   - Add `yourlang_spec.cr` with your test cases

### Testing

Run specific lexer tests:
```console
$ crystal spec spec/lexers/yourlang/
```

Update test fixtures:
```console
$ UPDATE_FIXTURE=1 crystal spec spec/lexers/yourlang/
```

Run all tests:
```console
$ crystal spec
```

## Note

This project is heavily inspired by [jneen/rouge](https://github.com/jneen/rouge).

## License

MIT and [:sushi:](https://github.com/MakeNowJust/sushi-ware)
© TSUYUSATO "[MakeNowJust](https://quine.codes)" Kitsune <<make.just.on@gmail.com>> 2016-2017
