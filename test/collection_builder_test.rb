require 'locca/collection_builder'
require 'minitest/autorun'
require 'mocha/mini_test'

class CollectionBuilderTest < MiniTest::Test

def setup
    @parser = mock('parser')
    @file_manager = mock('file_manager')

    @collection_builder = Locca::CollectionBuilder.new(@file_manager, @parser)
end

def test_builder
    collection_name = 'SomeName'
    collection_path = "/path/asdada/#{collection_name}.strings"
    
    file_contents = 'test_file_content'

    file = mock('file')
    @file_manager.expects(:open).with(collection_path, 'rb:BOM|UTF-8:UTF-8').yields(file)
    file.expects(:read).returns(file_contents)  

    collection_items = [['key1', 'value1', 'comment1'], ['key2', 'value2', 'comment2']]

    @parser.expects(:parse).with(file_contents).multiple_yields(collection_items[0], collection_items[1])

    collection = @collection_builder.collection_at_path(collection_path)

    assert(collection, 'collection is nil')
    assert_equal(collection_name, collection.name)
    refute(collection.lang)

    collection_items.each do |collection_item_array|
        item = collection.item_for_key(collection_item_array[0])
        assert(item, "collection item for key '#{collection_item_array[0]}' is nil")
        assert_equal(collection_item_array[0], item.key())
        assert_equal(collection_item_array[1], item.value())
        assert_equal(collection_item_array[2], item.comment())
    end
end

end