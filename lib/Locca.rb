
require 'Locca/version.rb'

require 'Locca/Genstrings.rb'

require 'Locca/Strings.rb'
require 'Locca/StringsSerialization.rb'

require 'Locca/Keyset.rb'

module Locca
	class Locca
		attr_reader :loccaDir
		attr_reader :workDir

		def initialize(workDir = nil, loccaDir = nil)
			@workDir, @loccaDir = workDir, loccaDir

			if not workDir
				workDir = Dir.pwd
			end
		end

		def build()
			objects = Array.new()

			Genstrings.generate(@workDir) do |filepath|
				stringsObj = StringsSerialization.stringsObjectWithFileAtPath(filepath)
				stringsObj.lang = 'en'
				objects.push(stringsObj)
			end

			puts objects
		end


		
	end
end