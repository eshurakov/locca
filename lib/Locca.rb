require 'set'

require 'Locca/version.rb'
require 'Locca/Config.rb'

require 'Locca/Genstrings.rb'

require 'Locca/Strings.rb'
require 'Locca/StringsSerialization.rb'
require 'Locca/StringsMerger.rb'

require 'Locca/Keyset.rb'

module Locca
	class Locca
		attr_reader :loccaDir
		attr_reader :workDir

		attr_reader :config

		def initialize(workDir = nil, loccaDir = nil)
			@workDir, @loccaDir = workDir, loccaDir

			if @workDir and not File.directory?(@workDir)
				raise ArgumentError, 'Work dir doesn\'t exist'
			end

			if not @workDir
				@workDir = Dir.pwd
			end

			@config = Config.new()
		end

		def build()
			generatedStrings = Array.new()
			Genstrings.generate(@workDir) do |stringsFilepath|
				stringsObj = StringsSerialization.stringsObjectWithFileAtPath(stringsFilepath)
				stringsObj.lang = @config.devLang
				generatedStrings.push(stringsObj)
			end


			keysets = {}
			availableLangs = Set.new

			Dir.glob(File.join(@workDir, '*.lproj')) do |filepath|
				lang = File.basename(filepath, '.lproj')
				availableLangs.add(lang)
				Dir.glob(File.join(filepath, '*.strings')) do |stringsFilepath|
					stringsObj = StringsSerialization.stringsObjectWithFileAtPath(stringsFilepath)
					stringsObj.lang = lang

					keyset = keysets[stringsObj.keysetName]
					if not keyset
						keyset = Keyset.new(stringsObj.keysetName)
						keysets[keyset.name] = keyset
					end

					keyset.addStringsObj(stringsObj)
				end
			end


			generatedStrings.each do |generatedStrings|
				keyset = keysets[generatedStrings.keysetName]
				if not keyset
					keyset = Keyset.new(generatedStrings.keysetName)
					keysets[keyset.name] = keyset
				end

				availableLangs.each do |lang|
					projectStrings = keyset.stringsForLang(lang)
					if projectStrings
						StringsMerger.merge(generatedStrings, projectStrings)
					else
						projectStrings = Marshal.load(Marshal.dump(generatedStrings))
						projectStrings.lang = lang
						projectStrings.filepath = File.join(@workDir, "#{lang}.lproj", "#{projectStrings.keysetName}.strings")

						keyset.addStringsObj(projectStrings)
					end
				end
			end

			keysets.each do |key, keyset|
				keyset.eachStrings do |projectStrings|
					if not projectStrings.filepath
						raise 'Path is not set for Strings. Can\'t write'
					end

					StringsSerialization.writeStringsObjectToFileAtPath(projectStrings, projectStrings.filepath)
				end
			end

		end


		
	end
end