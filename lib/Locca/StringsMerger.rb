
require_relative 'Strings'

module Locca
	class StringsMerger
		ACTION_ADD 			= (1 << 0)
		ACTION_DELETE 		= (1 << 1)
		
		def self.merge(srcStrings, dstStrings, actions = (ACTION_ADD | ACTION_DELETE))
			if not srcStrings or not dstStrings
				raise ArgumentError, 'source and destination objects should be set'
			end

			dstKeys = nil
			if (actions & ACTION_DELETE)
				dstKeys = dstStrings.keysArray
			end

			srcStrings.each do |key, value|
				if (actions & ACTION_ADD) and not dstStrings.hasKey?(key)
					dstStrings.addKey(key, value[:value], value[:comment])
				end

				if dstKeys
					dstKeys.delete(key)
				end
			end

			if dstKeys
				dstKeys.each do |key|
					dstStrings.removeKey(key)
				end
			end
		end

	end
end
