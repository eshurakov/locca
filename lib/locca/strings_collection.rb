
module Locca
	class StringsCollection
		attr_accessor :filepath
		attr_accessor :keyset_name
		attr_accessor :lang

		def initialize(filepath = nil, lang = nil)
			@filepath, @lang = filepath, lang
			if filepath
				@keyset_name = File.basename(@filepath, '.strings')
			end

			@items = {}
			@modified = false
		end

		def add_item(item)
			if !item || !item.key
				return
			end
			@modified = true
			@items[item.key] = item
		end

		def remove_item_for_key(key)
			item = @items.delete(key)
			if item
				@modified = true
			end
			return item
		end

		def item_for_key(key)
			return @items[key]
		end

		def has_key?(key)
			return @items.has_key?(key)
		end

		def all_keys
			return @items.keys
		end

		def modified=(val)
			@modified = val

			if !@modified
				@items.each do |key, item|
					item.modified = false
				end
			end
		end

		def modified?
			if @modified
				return true
			end

			@items.each do |key, item|
				if item.modified?
					return true
				end
			end

			return false
		end

		def count
			return @items.count
		end

		def each
			@items.each do |key, item|
				yield(item)
			end
		end	

		def sorted_each
			sorted_keys = all_keys.sort {|a,b| a.downcase <=> b.downcase || a <=> b}
			sorted_keys.each do |key|
				yield(@items[key])
			end
		end

		def to_s ; "<#{self.class}: filepath = #{filepath}, keysetName = #{keyset_name}>" ; end
	end
end