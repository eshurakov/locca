
require_relative 'config'

module Locca
	class Project
		attr_reader :config
		
		attr_reader :dir
		attr_reader :dev_lang

		def initialize(dir, locca_dir = nil)
			@dir = dir
			@config = Config.new()
			@dev_lang = 'en'
		end
	end
end