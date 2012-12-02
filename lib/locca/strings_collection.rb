
module Locca
	class StringsCollection
		attr_accessor :filepath
		attr_accessor :keyset_name
		attr_accessor :lang

		def initialize(filepath = nil, lang = nil)
			@filepath, @lang = filepath, lang
			if filepath
				@keyset_name = File.basename(@filepath, '.strings')
			end

			@strings = {}
		end

		def set_string_for_key(key, value, comment)
			@strings[key] = {:value => value, :comment => comment}
		end

		def remove_string_for_key(key)
			return @strings.delete(key)
		end

		def string_for_key(key)
			return @strings[key]
		end

		def has_key?(key)
			return @strings.has_key?(key)
		end

		def all_keys
			return @strings.keys
		end

		def count
			return @strings.count
		end

		def each
			@strings.each do |key, value|
				yield(key, value)
			end
		end	

		def sorted_each
			sorted_keys = all_keys.sort {|a,b| a.downcase <=> b.downcase || a <=> b}
			sorted_keys.each do |key|
				yield(key, @strings[key])
			end
		end

		def to_s ; "<#{self.class}: filepath = #{filepath}, keysetName = #{keyset_name}>" ; end
	end
end