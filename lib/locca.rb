require 'set'
require 'tempfile'
require 'open3'

require 'locca/version.rb'

require 'locca/project.rb'
require 'locca/config.rb'

require 'locca/genstrings.rb'

require 'locca/strings_collection.rb'
require 'locca/strings_item.rb'
require 'locca/strings_serialization.rb'
require 'locca/strings_merger.rb'

require 'locca/keyset.rb'

module Locca
	class Locca
		attr_reader :project

		def initialize(work_dir = nil, strings_dir = nil)
			@project = Project.project_with_dir(work_dir, strings_dir)

			if !@project
				if !work_dir
					raise 'Can\'t determine work dir for project'
				else
					raise "Can\'t find project for work dir: #{work_dir}"
				end
			end
		end

		def build(langs = nil)
			generated_collections = Array.new()
			Genstrings.generate(@project.dir) do |filepath|
				collection = StringsSerialization.strings_collection_with_file_at_path(filepath)
				generated_collections.push(collection)
			end

			keysets = {}

			if !langs
				langs = Set.new()
			end

			if langs.count == 0
				Dir.glob(File.join(@project.strings_dir, '*.lproj')) do |filepath|
					langs.add(File.basename(filepath, '.lproj'))
				end
			end

			langs.each do |lang|
				collections_for_lang(lang) do |collection|
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

				langs.each do |lang|
					project_collection = keyset.collection_for_lang(lang)
					if !project_collection
						project_collection = StringsCollection.new(File.join(@project.strings_dir, "#{lang}.lproj", "#{keyset.name}.strings"), lang)
						keyset.add_collection(project_collection)
					end

					StringsMerger.merge(generated_collection, project_collection)
				end
			end

			keysets.each do |key, keyset|
				keyset.each_collection do |project_collection|
					if not project_collection.filepath
						raise 'Path is not set for Collection. Can\'t write'
					end
					
					if project_collection.modified?
						StringsSerialization.write_strings_collection_to_file_at_path(project_collection, project_collection.filepath)
					end
				end
			end

		end

		def translate(lang)
			if !lang
				raise ArgumentError, 'language should be specified'
			end

			collections_for_lang(lang) do |collection|
				if collection.translated?
					next
				end

				translate_collection(collection)
				break
			end
		end

		def translate_collection(collection)
			editor = ENV['EDITOR']
			if !editor
				raise ArgumentError, 'EDITOR environment variable should be defined'
			end

			file = Tempfile.new("#{collection.keyset_name}-#{collection.lang}-")
			tmpCollection = StringsCollection.new()

			collection.each do |item|
				if item.translated?
					next
				end

				tmpCollection.add_item(item)
			end

			StringsSerialization.write_strings_collection_to_file_at_path(tmpCollection, file.path)

			command = "#{editor} #{file.path}"
			stdout,stderr,status = Open3.capture3(command)

			if status.success?
				translated_collection = StringsSerialization.strings_collection_with_file_at_path(file.path)
				StringsMerger.merge(translated_collection, collection, StringsMerger::ACTION_UPDATE)

				if collection.modified?
					StringsSerialization.write_strings_collection_to_file_at_path(collection, collection.filepath)
				end
			end

			file.close
			file.unlink
		end

		def collections_for_lang(lang)
			Dir.glob(File.join(project.strings_dir, "#{lang}.lproj", '*.strings')) do |filepath|
				collection = StringsSerialization.strings_collection_with_file_at_path(filepath)
				collection.lang = lang
				yield(collection)
			end
		end
	end
end