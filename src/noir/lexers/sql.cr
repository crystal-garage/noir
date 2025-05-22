require "../lexer"

class Noir::Lexers::SQL < Noir::Lexer
  tag "sql"
  aliases %w(sql)
  filenames %w(*.sql)
  mimetypes %w(text/x-sql text/x-sqlite)

  # SQL keywords
  KEYWORDS = %w(
    SELECT FROM WHERE GROUP BY ORDER BY HAVING
    INSERT INTO VALUES UPDATE SET DELETE
    CREATE DROP ALTER INDEX VIEW TRIGGER
    JOIN LEFT RIGHT INNER OUTER CROSS
    UNION ALL DISTINCT
    AND OR NOT
    AS ON IN EXISTS BETWEEN LIKE
    ASC DESC LIMIT OFFSET
    BEGIN COMMIT ROLLBACK TRANSACTION
    PRIMARY KEY FOREIGN KEY REFERENCES
    CONSTRAINT UNIQUE CHECK DEFAULT
    NULL NOT NULL
    TRUE FALSE
    CASE WHEN THEN ELSE END
    IF ELSEIF ELSE END IF
    PROCEDURE FUNCTION TRIGGER
    GRANT REVOKE
    DATABASE SCHEMA
  )

  # SQL data types
  TYPES = %w(
    INT INTEGER BIGINT SMALLINT TINYINT
    FLOAT DOUBLE DECIMAL NUMERIC
    CHAR VARCHAR TEXT LONGTEXT
    DATE DATETIME TIMESTAMP TIME
    BOOLEAN BOOL
    BLOB CLOB
    JSON XML
    ARRAY
  )

  # SQL functions
  FUNCTIONS = %w(
    COUNT SUM AVG MIN MAX
    CONCAT SUBSTRING REPLACE
    UPPER LOWER TRIM
    COALESCE NULLIF
    NOW CURRENT_TIMESTAMP
    DATE_FORMAT DATE_ADD DATE_SUB
    ROUND FLOOR CEIL
    LENGTH CHAR_LENGTH
    CAST CONVERT
  )

  state :root do
    # Comments (must be before operators)
    rule /--.*?$/m, Comment
    rule %r(/\*), Comment::Multiline, :multiline_comment
    rule %r(\*/), Error

    # Whitespace
    rule %r(\s+), Text::Whitespace

    # Strings
    rule %r('), Str::Single, :single_quoted_string
    rule %r("), Name::Variable, :double_quoted_string

    # Numbers
    rule %r(\d*\.\d+), Num::Float
    rule %r(\d+e[+-]?\d+), Num::Float
    rule %r(\d+), Num::Integer

    # Operators
    rule %r([+\-*/%&|^=<>!~]), Operator

    # Punctuation
    rule %r(\.), Punctuation
    rule %r([,;:()\[\]{}]), Punctuation

    # Keywords (must be before identifiers to prevent partial matches)
    rule %r(\b(#{KEYWORDS.join('|')})\b)i, Keyword

    # Types
    rule %r(\b(#{TYPES.join('|')})\b)i, Keyword::Type
    rule %r(\b(#{TYPES.join('|')})\([0-9,]+\)\b)i, Keyword::Type

    # Functions
    rule %r(\b(#{FUNCTIONS.join('|')})\b)i, Name::Function

    # Identifiers (including table and column names)
    rule %r([a-zA-Z_][a-zA-Z0-9_]*), Name

    # Parameters
    rule %r(\$[0-9]+), Name::Variable
    rule %r(\?[0-9]*), Name::Variable
    rule %r(:[a-zA-Z_][a-zA-Z0-9_]*), Name::Variable
  end

  state :multiline_comment do
    rule %r(\*/), Comment::Multiline, :pop!
    rule %r([^*/]+), Comment::Multiline
    rule %r([*/]), Comment::Multiline
  end

  state :single_quoted_string do
    rule %r(''), Str::Escape
    rule %r([^']+), Str::Single
    rule %r('), Str::Single, :pop!
  end

  state :double_quoted_string do
    rule %r(""), Str::Escape
    rule %r([^"]+), Name::Variable
    rule %r("), Name::Variable, :pop!
  end
end
