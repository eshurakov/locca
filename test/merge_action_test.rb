require 'locca/actions/merge_action'
require 'locca/collection_merger'

require 'minitest/autorun'
require 'mocha/mini_test'

class BuildActionTest < MiniTest::Test

def setup
    @collection_builder = mock('collection_builder')
    @collection_merger = mock('collection_merger')

    @src_path = '/test/src_path'
    @dst_path = '/test/dst_path'

    @action = Locca::MergeAction.new(@src_path, @dst_path, @collection_builder, @collection_merger)
end

def test_action
    src_collection = mock('src_collection')

    dst_collection = mock('dst_collection')
    dst_collection.expects(:write_to).with(@dst_path)

    @collection_builder.expects(:collection_at_path).with(@src_path).returns(src_collection)
    @collection_builder.expects(:collection_at_path).with(@dst_path).returns(dst_collection)

    @collection_merger.expects(:merge).with(src_collection, dst_collection, (Locca::CollectionMerger::ACTION_ADD | Locca::CollectionMerger::ACTION_UPDATE))

    @action.execute()
end

end