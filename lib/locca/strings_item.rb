
module Locca
	class StringsItem
		attr_reader :key
		attr_reader :value
		attr_reader :comment

		def initialize(key, value = nil, comment = nil)
			@key, @value, @comment = key, value, comment
			@modified = false
		end

		def initialize_copy(source)
			super
			@modified = false
		end

		def modified=(val)
			@modified = val
		end

		def modified?
			return @modified
		end

		def value=(val)
			if @value == val
				return
			end

			@value = val
			@modified = true
		end

		def comment=(val)
			if @comment == val
				return
			end
			@comment = val
			@modified = true
		end

	end
end