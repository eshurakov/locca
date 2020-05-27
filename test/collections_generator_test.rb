require 'locca/collections_generator'
require 'minitest/autorun'
require 'mocha/minitest'

class CollectionsGeneratorTest < MiniTest::Test

def setup
    @genstrings = mock('genstrings')
    @collection_builder = mock('collection_builder')
end

def test_generator
    file_paths = ['/path/file1', '/path/file2']
    collections = [mock('collection1'), mock('collection2')]

    collections_generator = Locca::CollectionsGenerator.new(file_paths, @genstrings, @collection_builder)

    collections.each_with_index do |collection, index|
        @collection_builder.expects(:collection_at_path).with(file_paths[index]).returns(collection)
    end

    @genstrings.expects(:generate).with(file_paths).multiple_yields(file_paths[0], file_paths[1])

    result_collections = collections_generator.generate()
    assert_equal(collections, result_collections)
end

end