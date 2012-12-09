
require_relative 'strings_collection'
require_relative 'strings_item'

module Locca
	class StringsMerger
		ACTION_ADD 			= (1 << 0)
		ACTION_DELETE 		= (1 << 1)
		ACTION_UPDATE 		= (1 << 2)
		
		def self.merge(src_collection, dst_collection, actions = (ACTION_ADD | ACTION_DELETE))
			if not src_collection or not dst_collection
				raise ArgumentError, 'Source and Destination Collections should be set'
			end

			dst_keys = nil
			if (actions & ACTION_DELETE) != 0
				dst_keys = dst_collection.all_keys
			end

			src_collection.each do |src_item|
				dst_item = dst_collection.item_for_key(src_item.key)

				if (actions & ACTION_ADD) != 0 && !dst_item
					dst_collection.add_item(src_item.dup)
				elsif (actions & ACTION_UPDATE) != 0 && dst_item
					dst_item.value = src_item.value
					dst_item.comment = src_item.comment
				end

				if dst_keys
          			dst_keys.delete(src_item.key)
				end
			end

			if dst_keys
        		dst_keys.each do |key|
          			dst_collection.remove_item_for_key(key)
				end
			end
		end

	end
end
