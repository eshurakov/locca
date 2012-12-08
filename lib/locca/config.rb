
module Locca
	class Config
		attr_reader :dev_lang

		def initialize(filename = nil)
			@dev_lang = 'en'
		end
	end
end