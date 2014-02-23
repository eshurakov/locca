
module Locca
    class ConfigValidator
        attr_accessor :fields

        def initialize(fields = nil)
            @fields = fields
        end

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