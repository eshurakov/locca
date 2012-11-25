module Babelyoda
  class StringsLexer
    TOKENS = [ :multiline_comment, :singleline_comment, :string, :equal_sign, :semicolon, :space ].freeze
    REGEXP = Regexp.new("/\\*\\s*(.*?)\\s*\\*/|\\s*(//.*?\n)|\"((?:\\\\?+.)*?)\"|(\\s*=\\s*)|(\\s*;\\s*)|(\\s*)", Regexp::MULTILINE)

    def lex(str)
		str.scan(REGEXP).each do |m|
			idx = m.index { |x| x }
			if TOKENS[idx] == :space
				next
			end

			yield TOKENS[idx], m[idx]
		end
    end
  end
end