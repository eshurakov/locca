require 'minitest/autorun'
require 'mocha/mini_test'

require 'locca/collection'
require 'locca/collection_item'
require 'locca/collection_merger'

class CollectionMergerTest < MiniTest::Test

def setup
    @merger = Locca::CollectionMerger.new()

    @base_items = [
        item("Account", "Cuenta", "Account settings page"),
        item("Account Name", "Nombre de cuenta", "Account settings page"),
    ]

    @added_items = [
        item("Support", "Support", "No comment provided by engineer"),
        item("Reminder", "Rappel", "Reminder view title")
    ]

    @removed_items = [
        item("Delete", "Удалить", "No Comment"),
        item("Yesterday", "Вчера", "No Comment")
    ]

    @updated_items = [
        item("Account", "Accounto", "Account settings page new comment"),
    ]

# ----

    @src_collection = base_collection()
    @added_items.each do |item|
        @src_collection.add_item(item)
    end
    @updated_items.each do |item|
        @src_collection.add_item(item)
    end

# ----

    @dst_collection = base_collection()
    @removed_items.each do |item|
        @dst_collection.add_item(item)
    end
end

def item(key, value, comment)
    return Locca::CollectionItem.new(key, value, comment)
end

def base_collection()
    collection = Locca::Collection.new()
    @base_items.each do |item|
        collection.add_item(item)
    end
    return collection
end

def test_merge_add
    @merger.merge(@src_collection, @dst_collection, Locca::CollectionMerger::ACTION_ADD)

    assert_equal(@base_items.count + @added_items.count + @removed_items.count, @dst_collection.count)

    @added_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key))
    end

    @removed_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key))
    end

    @base_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key)) 
    end
end

def test_merge_delete
    @merger.merge(@src_collection, @dst_collection, Locca::CollectionMerger::ACTION_DELETE)

    assert_equal(@base_items.count, @dst_collection.count)

    @added_items.each do |item|
        refute(@dst_collection.has_key?(item.key))
    end

    @removed_items.each do |item|
        refute(@dst_collection.has_key?(item.key))
    end

    @base_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key)) 
    end
end

def test_merge_update
    @merger.merge(@src_collection, @dst_collection, Locca::CollectionMerger::ACTION_UPDATE)

    assert_equal(@base_items.count + @removed_items.count, @dst_collection.count)

    @added_items.each do |item|
        refute(@dst_collection.has_key?(item.key))
    end

    @removed_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key))
    end

    @updated_items.each do |item|
        assert_equal(item, @dst_collection.item_for_key(item.key)) 
    end
end

end