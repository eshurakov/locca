
require_relative 'Strings'

module Locca
	class Keyset
		attr_reader :name

		def initialize(name)
			@name = name
			@objects = {}
		end

		def setStringsForLang(strings, lang)
			@objects[lang] = strings
		end

		def stringsForLang(lang)
			return @objects[lang]
		end

	end
end
