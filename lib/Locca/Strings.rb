
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

		def addKey(key, value, comment)
			@keys[key] = {:value => value, :comment => comment}
		end

		def to_s ; "<#{self.class}: filepath = #{filepath}, keysetName = #{keysetName}>" ; end
	end
end