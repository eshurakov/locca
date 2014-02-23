
module Locca
    class CollectionItem
        attr_reader :key
        attr_reader :value
        attr_reader :comment
        
        def initialize(key, value = nil, comment = nil)
            @key = key
            @value = value
            @comment = comment
        end

        def initialize_copy(source)
            super
        end

        def ==(item)
            if item
                return @key == item.key && @value == item.value && @comment == item.comment
            else
                return false
            end
        end

        def translated?
            value = nil
            if @value
                value = @value.gsub(/%\d+\$/, "%")
            end

            if @key == value
                return false
            end

            return true
        end
    end
end