# require 'locca'
# require 'minitest/autorun'

# class CollectionLoaderTest < MiniTest::Test

# def setup

# end

# def teardown

# end

# def test_file_encodings
#     filenames = %w(
#         Localizable_utf8.strings
#         Localizable_nocomments_utf8.strings
#         Localizable_utf8_bom.strings
#         Localizable_utf16le.strings
#         Localizable_utf16be.strings
#     )

#     master_keys = ['Account', 'Account Name', 'Alert', 'Back', 'Clear', 'Debug', 'Default', 'Delete', 'Error', 'Mark as completed', 'Move to...', 'Tap to set alert', 'View Details', 'Yesterday']

#     filenames.each do |filename|
#         filepath = File.join(Dir.pwd, 'test', 'Fixtures', filename)
#         collection = Locca::StringsSerialization.strings_collection_with_file_at_path(filepath)
#         assert(collection, "Nil Collection for file #{filename}")
#         assert_equal(14, collection.count)

#         master_keys.each do |key|
#             assert(collection.has_key?(key), "Missing key: #{key}")
#             item = collection.item_for_key(key)
#             assert(item)
#             assert(item.key)
#             if filename != 'Localizable_nocomments_utf8.strings'
#                 assert(item.comment)
#             end
            
#             assert(item.value)
#         end
#     end

# end

# end
