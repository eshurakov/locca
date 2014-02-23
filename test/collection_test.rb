require 'locca/collection'
require 'locca/collection_item'
require 'minitest/autorun'

class CollectionTest < MiniTest::Test

def test_init
    name = 'test1'
    lang = 'test2'
    collection = Locca::Collection.new(name, lang)
    assert(collection)
    assert_equal(0, collection.count)
    assert_equal([], collection.all_keys)
    assert_equal(name, collection.name)
    assert_equal(lang, collection.lang)
end

def test_add_item
    item_key = 'key'
    collection_item = Locca::CollectionItem.new(item_key)

    collection = Locca::Collection.new()
    collection.add_item(collection_item)

    assert_equal(1, collection.count)
    assert_equal([item_key], collection.all_keys)

    assert(collection.has_key?(item_key))
    assert_equal(collection_item, collection.item_for_key(item_key))
end

def test_remove_item
    item_key = 'key'
    collection_item = Locca::CollectionItem.new(item_key)

    collection = Locca::Collection.new()
    collection.add_item(collection_item)
    collection.remove_item_for_key(item_key)

    assert_equal(0, collection.count)
    assert_equal([], collection.all_keys)
    refute(collection.has_key?(item_key))
    refute(collection.item_for_key(item_key))
end

end