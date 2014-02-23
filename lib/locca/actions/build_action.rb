
module Locca
    class BuildAction
        def initialize(project, collections_builder, collections_generator, collection_merger)
            @project = project
            @collections_generator = collections_generator
            @collection_merger = collection_merger
            @collections_builder = collections_builder
        end

        def execute()
            generated_collections = @collections_generator.generate(@project.code_dir())
            langs = @project.langs()

            generated_collections.each do |generated_collection|
                langs.each do |lang|
                    collection_path = File.join(@project.lang_dir, "#{lang}.lproj", "#{generated_collection.name}.strings")

                    collection = @collections_builder.collection_at_path(collection_path)

                    @collection_merger.merge(generated_collection, collection)

                    collection.write_to(collection_path)
                end
            end
        end
    end
end