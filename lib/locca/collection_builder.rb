require_relative 'collection'
require_relative 'collection_item'

module Locca
    class CollectionBuilder
        def initialize(file_manager, parser)
            @file_manager = file_manager
            @parser = parser
        end

        def collection_at_path(path)
            name = File.basename(path, '.strings')
            collection = Collection.new(name)

            @file_manager.open(path, 'rb:BOM|UTF-8:UTF-8') do |file|
                @parser.parse(file.read()) do |key, value, comment|
                    collection.add_item(CollectionItem.new(key, value, comment))
                end
            end

            return collection
        end
    end
end