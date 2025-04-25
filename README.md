# NOIR

Syntax Highlight Library for [Crystal](https://crystal-lang.org)

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
