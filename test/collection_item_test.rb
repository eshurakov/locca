require 'locca/collection_item'
require 'minitest/autorun'
require 'mocha/minitest'

class CollectionItemTest < MiniTest::Test

def test_item_not_translated
    item = Locca::CollectionItem.new('Alert at %02i:%02i %@', 'Alert at %1$02i:%2$02i %3$@')
    assert(item)
    refute(item.translated?)
end

def test_item_translated
    item = Locca::CollectionItem.new('Alert at %02i:%02i %@', 'Alarme : %1$02i:%2$02i %3$@')
    assert(item)
    assert(item.translated?)
end

end