
module Locca
    class Collection
        attr_accessor :name
        attr_accessor :lang

        def initialize(name = nil, lang = nil)
            @name = name 
            @lang = lang
            @items = {}
        end

        def add_item(item)
            if !item || !item.key
                raise ArgumentError, 'item or item.key is nil'
            end
            @items[item.key] = item
        end

        def remove_item_for_key(key)
            return @items.delete(key)
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

        def translated?
            @items.each do |key, item|
                if !item.translated?
                    return false
                end
            end

            return true
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
            sorted_keys = all_keys.sort(&:casecmp)
            sorted_keys.each do |key|
                yield(@items[key])
            end
        end

        def write_to(filepath)
            if not filepath
                raise ArgumentException, 'filepath can\'t be nil'
            end

            FileUtils.mkdir_p(File.dirname(filepath))

            File.open(filepath, "w") do |io|
                sorted_each do |item|
                    key = item.key.gsub(/([^\\])"/, "\\1\\\"")
                    value = item.value.gsub(/([^\\])"/, "\\1\\\"")
                    
                    io << "/* #{item.comment} */\n" if item.comment
                    io << "\"#{key}\" = \"#{value}\";\n"
                    io << "\n"
                end
            end
        end

        def to_s ; "<#{self.class}: lang = #{lang}, name = #{name}>" ; end
    end
end