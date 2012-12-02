require 'test_helper'
require 'locca'

class StringsMergerTest < Test::Unit::TestCase

	def test_merge

		filepath = File.join(Dir.pwd, 'test', 'Fixtures', 'Localizable_modified.strings')
		src_collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
  		assert(src_collection, "Nil Collection for file #{filepath}")

  		filepath = File.join(Dir.pwd, 'test', 'Fixtures', 'Localizable_utf8.strings')
  		dst_collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
  		assert(dst_collection, "Nil Collection for file #{filepath}")

  		master_keys = ['Account', 'Account Name', 'Alert', 'Back', 'Clear', 'Debug', 'Default', 'Delete', 'Error', 'Mark as completed', 'Move to...', 'Tap to set alert', 'View Details', 'Yesterday']
  		added_keys = ['Support', 'Status', 'Reminder']
  		removed_keys = ['Delete', 'Default', 'Yesterday']

  		Locca::StringsMerger.merge(src_collection, dst_collection, Locca::StringsMerger::ACTION_ADD)

  		assert_equal(master_keys.count + added_keys.count, dst_collection.count)

  		added_keys.each do |key|
  			assert(dst_collection.has_key?(key))
  		end

  		removed_keys.each do |key|
  			assert(dst_collection.has_key?(key))
  		end

  		filepath = File.join(Dir.pwd, 'test', 'Fixtures', 'Localizable_utf8.strings')
  		dst_collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
  		assert(dst_collection, "Nil Collection for file #{filepath}")

		Locca::StringsMerger.merge(src_collection, dst_collection, Locca::StringsMerger::ACTION_ADD | Locca::StringsMerger::ACTION_DELETE)

		assert_equal(master_keys.count + added_keys.count - removed_keys.count, dst_collection.count)

  		added_keys.each do |key|
  			assert(dst_collection.has_key?(key))
  		end

  		removed_keys.each do |key|
  			assert(!dst_collection.has_key?(key))
  		end  		

	end

end