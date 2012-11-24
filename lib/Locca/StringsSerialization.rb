require 'rchardet19'

require 'Babelyoda/strings_lexer'
require 'Babelyoda/strings_parser'

require_relative 'Strings'

module Locca
	class StringsSerialization
		def self.stringsObjectWithFileAtPath(filepath)
			if !File.exists?(filepath)
				return nil
			end

			lexer = Babelyoda::StringsLexer.new()
	        parser = Babelyoda::StringsParser.new(lexer)
	        stringsObj = Strings.new(filepath)

			File.open(filepath, self.readModeForFileAtPath(filepath)) do |file|
				parser.parse(file.read) do |key, value, comment|
		        	stringsObj.addKey(key, value, comment)
		        end
			end

	        return stringsObj
		end

		def self.readModeForFileAtPath(filepath)
			cd = CharDet.detect(File.read(filepath))
			encoding_str = Encoding.aliases[cd.encoding] || cd.encoding
			encoding_str = 'UTF-8' if encoding_str == 'utf-8'
			encoding_str = 'UTF-8' if encoding_str == 'ascii'
			if (encoding_str != "UTF-8")
				return "rb:#{encoding_str}:UTF-8"
		 	else
				return "r"
		 	end
		end

		def self.dataWithStringsObject(stringsObj)

		end
	end
end