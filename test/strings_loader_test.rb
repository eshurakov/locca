require 'test_helper'
require 'locca'

class StringsLoaderTest < Test::Unit::TestCase

  def setup

  end

  def teardown

  end

  def test_file_encodings
  	filenames = %w(
  		Localizable_utf8.strings
  		Localizable_utf8_bom.strings
  		Localizable_utf16le.strings
  		Localizable_utf16be.strings
  	)

  	master_keys = ['Account', 'Account Name', 'Alert', 'Back', 'Clear', 'Debug', 'Default', 'Delete', 'Error', 'Mark as completed', 'Move to...', 'Tap to set alert', 'View Details', 'Yesterday']

  	filenames.each do |filename|
  		filepath = File.join(Dir.pwd, 'test', 'Fixtures', filename)
  		collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
  		assert(collection, "Nil Collection for file #{filename}")
  		assert_equal(14, collection.count)
  		
  		master_keys.each do |key|
  			assert(collection.has_key?(key))
  			string = collection.string_for_key(key)
  			assert_not_nil(string)
  			assert_not_nil(string[:comment])
  			assert_not_nil(string[:value])
  		end
  	end
  end



end
