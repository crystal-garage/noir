require "../../spec_helper"
require "../../../src/noir/lexers/sql"

describe Noir::Lexers::SQL do
  it "can find canonical name 'sql'" do
    Noir.find_lexer("sql").should be_a(Noir::Lexers::SQL)
  end

  it_lexes_fixtures "sql", Noir::Lexers::SQL

  describe "comments" do
    it "tokenizes single line comments" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("-- This is a comment", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Comment, "-- This is a comment"].inspect)
    end

    it "tokenizes multi-line comments" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("/* This is a\nmulti-line comment */", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Comment::Multiline, "/* This is a\nmulti-line comment */"].inspect)
    end
  end

  describe "keywords" do
    it "tokenizes SQL keywords" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("SELECT FROM WHERE", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Keyword, "SELECT"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Keyword, "FROM"].inspect)
      lines[3].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[4].should eq([Noir::Tokens::Keyword, "WHERE"].inspect)
    end

    it "does not tokenize keywords inside identifiers" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("table_name order_id", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Name, "table_name"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Name, "order_id"].inspect)
    end
  end

  describe "strings" do
    it "tokenizes single quoted strings" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("'Hello, World!'", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Str::Single, "'Hello, World!'"].inspect)
    end

    it "tokenizes double quoted identifiers" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("\"column_name\"", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Name::Variable, "\"column_name\""].inspect)
    end
  end

  describe "numbers" do
    it "tokenizes integers" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("123", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Num::Integer, "123"].inspect)
    end

    it "tokenizes floating point numbers" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("123.45", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Num::Float, "123.45"].inspect)
    end
  end

  describe "operators" do
    it "tokenizes comparison operators" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("= <> < > <= >=", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Operator, "="].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Operator, "<>"].inspect)
      lines[3].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[4].should eq([Noir::Tokens::Operator, "<"].inspect)
      lines[5].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[6].should eq([Noir::Tokens::Operator, ">"].inspect)
      lines[7].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[8].should eq([Noir::Tokens::Operator, "<="].inspect)
      lines[9].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[10].should eq([Noir::Tokens::Operator, ">="].inspect)
    end

    it "tokenizes arithmetic operators" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("+ - * / %", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Operator, "+"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Operator, "-"].inspect)
      lines[3].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[4].should eq([Noir::Tokens::Operator, "*"].inspect)
      lines[5].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[6].should eq([Noir::Tokens::Operator, "/"].inspect)
      lines[7].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[8].should eq([Noir::Tokens::Operator, "%"].inspect)
    end
  end

  describe "functions" do
    it "tokenizes function names" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("COUNT(*)", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Name::Function, "COUNT"].inspect)
    end

    it "tokenizes function calls with parameters" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("CONCAT(first_name, ' ', last_name)", lexer: lexer, formatter: formatter)
      formatter.to_s.lines.first.should eq([Noir::Tokens::Name::Function, "CONCAT"].inspect)
    end
  end

  describe "data types" do
    it "tokenizes SQL data types" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("INTEGER VARCHAR(255) DECIMAL(10,2)", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines.size.should eq(13)
      lines[0].should eq([Noir::Tokens::Keyword::Type, "INTEGER"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Keyword::Type, "VARCHAR"].inspect)
      lines[3].should eq([Noir::Tokens::Punctuation, "("].inspect)
      lines[4].should eq([Noir::Tokens::Num::Integer, "255"].inspect)
      lines[5].should eq([Noir::Tokens::Punctuation, ")"].inspect)
      lines[6].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[7].should eq([Noir::Tokens::Keyword::Type, "DECIMAL"].inspect)
      lines[8].should eq([Noir::Tokens::Punctuation, "("].inspect)
      lines[9].should eq([Noir::Tokens::Num::Integer, "10"].inspect)
      lines[10].should eq([Noir::Tokens::Punctuation, ","].inspect)
      lines[11].should eq([Noir::Tokens::Num::Integer, "2"].inspect)
      lines[12].should eq([Noir::Tokens::Punctuation, ")"].inspect)
    end
  end

  describe "parameters" do
    it "tokenizes positional parameters" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("$1 $2", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Name::Variable, "$1"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Name::Variable, "$2"].inspect)
    end

    it "tokenizes named parameters" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight(":name :age", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Name::Variable, ":name"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Name::Variable, ":age"].inspect)
    end

    it "tokenizes question mark parameters" do
      lexer = Noir::Lexers::SQL.new
      formatter = SpecFormatter.new
      Noir.highlight("? ?", lexer: lexer, formatter: formatter)
      lines = formatter.to_s.lines
      lines[0].should eq([Noir::Tokens::Name::Variable, "?"].inspect)
      lines[1].should eq([Noir::Tokens::Text::Whitespace, " "].inspect)
      lines[2].should eq([Noir::Tokens::Name::Variable, "?"].inspect)
    end
  end
end
