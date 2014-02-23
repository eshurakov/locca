require 'locca/version'

require 'locca/project'
require 'locca/project_dir_locator'
require 'locca/project_factory'

require 'locca/config_reader'
require 'locca/config_validator'

require 'locca/actions/build_action'

require 'locca/collections_generator'
require 'locca/collection_merger'
require 'locca/collection_builder'

require 'locca/genstrings'

require 'babelyoda/strings_lexer'
require 'babelyoda/strings_parser'

module Locca
    class Locca
        attr_reader :project

        def initialize(project)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end

            @project = project
        end        

        def build()
            parser = Babelyoda::StringsParser.new(Babelyoda::StringsLexer.new())

            genstrings = Genstrings.new()
            collection_builder = CollectionBuilder.new(File, parser)
            collections_generator = CollectionsGenerator.new(genstrings, collection_builder)
            collection_merger = CollectionMerger.new()

            action = BuildAction.new(@project, collection_builder, collections_generator, collection_merger)
            action.execute()
        end

        # def translate(lang)
        #     if !lang
        #         raise ArgumentError, 'language should be specified'
        #     end

        #     collections_for_lang(lang) do |collection|
        #         if collection.translated?
        #             next
        #         end

        #         translate_collection(collection)
        #         break
        #     end
        # end

        # def translate_collection(collection)
        #     editor = ENV['EDITOR']
        #     if !editor
        #         raise ArgumentError, 'EDITOR environment variable should be defined'
        #     end

        #     file = Tempfile.new("#{collection.keyset_name}-#{collection.lang}-")
        #     tmpCollection = StringsCollection.new()

        #     collection.each do |item|
        #         if item.translated?
        #             next
        #         end

        #         tmpCollection.add_item(item)
        #     end

        #     StringsSerialization.write_strings_collection_to_file_at_path(tmpCollection, file.path)

        #     command = "#{editor} #{file.path}"
        #     stdout,stderr,status = Open3.capture3(command)

        #     if status.success?
        #         translated_collection = StringsSerialization.strings_collection_with_file_at_path(file.path)
        #         StringsMerger.merge(translated_collection, collection, StringsMerger::ACTION_UPDATE)

        #         if collection.modified?
        #             StringsSerialization.write_strings_collection_to_file_at_path(collection, collection.filepath)
        #         end
        #     end

        #     file.close
        #     file.unlink
        # end

        # def collections_for_lang(lang)
        #     Dir.glob(File.join(project.strings_dir, "#{lang}.lproj", '*.strings')) do |filepath|
        #         collection = StringsSerialization.strings_collection_with_file_at_path(filepath)
        #         collection.lang = lang
        #         yield(collection)
        #     end
        # end
    end
end