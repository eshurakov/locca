require 'rchardet19'

require 'babelyoda/strings_lexer'
require 'babelyoda/strings_parser'

require_relative 'strings_collection'
require_relative 'strings_item'

module Locca
	class StringsSerialization
		def self.strings_collection_with_file_at_path(filepath)
			if !File.exists?(filepath)
				raise "File \"#{filepath}\" not found"
			end

			lexer = Babelyoda::StringsLexer.new()
	        parser = Babelyoda::StringsParser.new(lexer)
	        collection = StringsCollection.new(filepath)
	        
			File.open(filepath, self.read_mode_for_file_at_path(filepath)) do |file|
				parser.parse(file.read) do |key, value, comment|
					collection.add_item(StringsItem.new(key, value, comment))
		    	end
			end

			collection.reset_modified_status()

	    	return collection
		end

		def self.read_mode_for_file_at_path(filepath)
			cd = nil
			File.open(filepath) do |file|
				cd = CharDet.detect(file.read(512))
			end
			encoding_str = Encoding.aliases[cd.encoding] || cd.encoding
			encoding_str = 'UTF-8' if encoding_str == 'utf-8'
			encoding_str = 'UTF-8' if encoding_str == 'ascii'
			if (encoding_str != "UTF-8")
				return "rb:#{encoding_str}:UTF-8"
		 	else
				return "r"
		 	end
		end

		def self.write_strings_collection_to_file_at_path(collection, filepath)
			if not filepath
				raise ArgumentException, 'filepath can\'t be nil'
			end

			FileUtils.mkdir_p(File.dirname(filepath))

			File.open(filepath, "wb") do |io|
				collection.sorted_each do |item|
					key = item.key.gsub(/([^\\])"/, "\\1\\\"")
					value = item.value.gsub(/([^\\])"/, "\\1\\\"")
					
					io << "/* #{item.comment} */\n" if item.comment
					io << "\"#{key}\" = \"#{value}\";\n"
					io << "\n"

				end
			end
		end
	end
end