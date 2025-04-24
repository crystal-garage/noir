require "../../spec_helper"
require "../../../src/noir/lexers/xml"

describe Noir::Lexers::XML do
  it "can find canonical name 'xml'" do
    Noir.find_lexer("xml").should be_a(Noir::Lexers::XML)
  end

  it_lexes_fixtures "xml", Noir::Lexers::XML
end
