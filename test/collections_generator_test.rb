require 'locca/collections_generator'
require 'minitest/autorun'
require 'mocha/mini_test'

class CollectionsGeneratorTest < MiniTest::Test

def setup
    @genstrings = mock('genstrings')
    @collection_builder = mock('collection_builder')

    @collections_generator = Locca::CollectionsGenerator.new(@genstrings, @collection_builder)
end

def test_generator
    code_dir = '/test/dir'
    file_paths = ['/path/file1', '/path/file2']
    collections = [mock('collection1'), mock('collection2')]

    collections.each_with_index do |collection, index|
        @collection_builder.expects(:collection_at_path).with(file_paths[index]).returns(collection)
    end

    @genstrings.expects(:generate).with(code_dir).multiple_yields([file_paths[0]], [file_paths[1]])

    result_collections = @collections_generator.generate(code_dir)
    assert_equal(collections, result_collections)
end

end