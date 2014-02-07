require 'locca'
require 'minitest/autorun'

class CollectionTest < MiniTest::Test

	def test_modification
		filepath = File.join(Dir.pwd, 'test', 'Fixtures', 'Localizable_utf8.strings')
  		collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
  		assert(collection, "Nil Collection for file #{filepath}")  		
	end

	def test_item_modification
		item = Locca::StringsItem.new('key', 'value', 'comment')
		assert(item)
		assert(!item.modified?)
		assert_equal('key', item.key);
		assert_equal('value', item.value);
		assert_equal('comment', item.comment);

		item.value = 'value1'
		assert(item.modified?)

		cloned_item = item.dup
		assert(cloned_item)
		assert(!cloned_item.modified?)

		assert_equal('key', cloned_item.key);
		assert_equal('value1', cloned_item.value);
		assert_equal('comment', cloned_item.comment);

		cloned_item.value = 'value2'
		assert(cloned_item.modified?)

		assert_equal('value1', item.value);
		assert_equal('value2', cloned_item.value);

		cloned_item.modified = false
		cloned_item.value = 'value2'
		assert(!cloned_item.modified?)

		cloned_item.value = 'Value2'
		assert(cloned_item.modified?)		
	end

	def test_item_translation
		item = Locca::StringsItem.new('Alert at %02i:%02i %@', 'Alert at %1$02i:%2$02i %3$@')
		assert(item)
		assert(!item.translated?)
		assert(!item.modified?)

		item.value = 'Alarme : %1$02i:%2$02i %3$@'
		assert(item.translated?)
		assert(item.modified?)
	end

end