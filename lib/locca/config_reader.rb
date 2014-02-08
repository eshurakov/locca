require 'yaml'

module Locca
    class ConfigReader
        def read(path)
            return YAML.load_file(path)
        end
    end
end