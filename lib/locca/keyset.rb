
require_relative 'strings_collection'

module Locca
	class Keyset
		attr_reader :name

		def initialize(name)
			@name = name
			@collections = {}
		end

		def add_collection(collection)
			@collections[collection.lang] = strings
		end

		def collection_for_lang(lang)
			return @collections[lang]
		end

		def each_collection
			@collections.each do |key, collection|
				yield(collection)
			end
		end

	end
end
