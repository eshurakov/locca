
module Locca
    class Project
        attr_reader :config
        attr_reader :dir
        attr_reader :strings_dir

        def initialize(dir, config)
            @dir = dir
            @config = config
        end

    end
end