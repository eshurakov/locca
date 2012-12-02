
module Locca
	class Config
		attr_reader :dev_lang

		def initialize()
			@dev_lang = 'en'
		end
	end
end