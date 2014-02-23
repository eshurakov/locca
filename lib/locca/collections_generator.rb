
module Locca
    class CollectionsGenerator
        def initialize(genstrings, collection_builder)
            @genstrings = genstrings
            @collection_builder = collection_builder
        end

        def generate(code_dir)
            result = Array.new()
            @genstrings.generate(code_dir) do |filepath|
                collection = @collection_builder.collection_at_path(filepath)
                result.push(collection)
            end
            return result
        end
    end
end