
module Locca
    class ConfigValidator
        attr_accessor :fields

        def validate(hash)
            if not @fields 
                return true
            end

            @fields.each do |field|
                if not hash.has_key?(field)
                    return false
                end
            end

            return true
        end
    end
end