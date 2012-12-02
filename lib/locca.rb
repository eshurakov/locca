require 'set'

require 'locca/version.rb'
require 'locca/config.rb'

require 'locca/genstrings.rb'

require 'locca/strings_collection.rb'
require 'locca/strings_serialization.rb'
require 'locca/strings_merger.rb'

require 'locca/keyset.rb'

module Locca
	class Locca
		attr_reader :locca_dir
		attr_reader :work_dir

		attr_reader :config

		def initialize(work_dir = nil, locca_dir = nil)
			@work_dir, @locca_dir = work_dir, locca_dir

			if @work_dir and not File.directory?(@work_dir)
				raise ArgumentError, 'Work dir doesn\'t exist'
			end

			if not @work_dir
				@work_dir = Dir.pwd
			end

			@config = Config.new()
		end

		def build()
			generated_collections = Array.new()
			Genstrings.generate(@work_dir) do |strings_filepath|
				collection = StringsSerialization.strings_collection_with_file_at_path(strings_filepath)
				collection.lang = @config.dev_lang
				generated_collections.push(collection)
			end


			keysets = {}
			available_langs = Set.new

			Dir.glob(File.join(@work_dir, '*.lproj')) do |filepath|
				lang = File.basename(filepath, '.lproj')
				available_langs.add(lang)
				Dir.glob(File.join(filepath, '*.strings')) do |strings_filepath|
					collection = StringsSerialization.stringsObjectWithFileAtPath(strings_filepath)
					collection.lang = lang

					keyset = keysets[collection.keyset_name]
					if not keyset
						keyset = Keyset.new(collection.keyset_name)
						keysets[keyset.name] = keyset
					end

					keyset.add_collection(collection)
				end
			end


			generated_collections.each do |generated_collection|
				keyset = keysets[generated_collection.keyset_name]
				if not keyset
					keyset = Keyset.new(generated_collection.keyset_name)
					keysets[keyset.name] = keyset
				end

				available_langs.each do |lang|
					project_collection = keyset.collection_for_lang(lang)
					if project_collection
						StringsMerger.merge(generated_collection, project_collection)
					else
						project_collection = Marshal.load(Marshal.dump(generated_collection))
						project_collection.lang = lang
						project_collection.filepath = File.join(@work_dir, "#{lang}.lproj", "#{project_collection.keyset_name}.strings")

						keyset.add_collection(project_collection)
					end
				end
			end

			keysets.each do |key, keyset|
				keyset.each_collection do |project_collection|
					if not project_collection.filepath
						raise 'Path is not set for Collection. Can\'t write'
					end

					StringsSerialization.write_strings_collection_to_file_at_path(project_collection, project_collection.filepath)
				end
			end

		end


		
	end
end