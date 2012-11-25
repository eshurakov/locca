
require_relative 'Strings'

module Locca
	class Keyset
		attr_reader :name

		def initialize(name)
			@name = name
			@objects = {}
		end

		def addStringsObj(strings)
			@objects[strings.lang] = strings
		end

		def stringsForLang(lang)
			return @objects[lang]
		end

		def eachStrings
			@objects.each do |key, obj|
				yield(obj)
			end
		end

	end
end
