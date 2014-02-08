
module Locca
    class Project
        attr_reader :dir
        attr_reader :code_dir
        attr_reader :lang_dir

        attr_reader :base_lang

        def initialize(dir, config)
            @dir = dir
            
            @code_dir = File.join(dir, config.code_dir)
            @lang_dir = File.join(dir, config.lang_dir)

            @base_lang = config.base_lang
        end

    end
end