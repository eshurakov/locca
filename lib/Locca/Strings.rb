
module Locca
	class Strings
		attr_accessor :filepath
		attr_accessor :keysetName
		attr_accessor :lang

		def initialize(filepath = nil, lang = nil)
			@filepath, @lang = filepath, lang
			if filepath
				@keysetName = File.basename(@filepath, '.strings')
			end

			@keys = {}
		end

		def setKeys(keys)
			@keys = keys
		end

		def addKey(key, value, comment)
			@keys[key] = {:value => value, :comment => comment}
		end

		def removeKey(key)
			return @keys.delete(key)
		end

		def hasKey?(key)
			return @keys.has_key?(key)
		end

		def keysArray
			return @keys.keys
		end

		def each()
			@keys.each do |key, value|
				yield(key, value)
			end
		end

		def test1
			@keys['Account'][:value] = 'test'
		end

		def test2
			puts @keys['Account']
		end		

		def sortedEach()
			sortedKeys = @keys.keys.sort {|a,b| a.downcase <=> b.downcase || a <=> b}
			sortedKeys.each do |key|
				yield(key, @keys[key])
			end
		end

		def to_s ; "<#{self.class}: filepath = #{filepath}, keysetName = #{keysetName}>" ; end
	end
end