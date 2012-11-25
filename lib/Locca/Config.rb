
module Locca
	class Config
		attr_reader :devLang

		def initialize()
			@devLang = 'en'
		end
	end
end