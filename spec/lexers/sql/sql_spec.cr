require "../../spec_helper"
require "../../../src/noir/lexers/sql"

describe Noir::Lexers::SQL do
  it "can find canonical name 'sql'" do
    Noir.find_lexer("sql").should be_a(Noir::Lexers::SQL)
  end

  it_lexes_fixtures "sql", Noir::Lexers::SQL
end
