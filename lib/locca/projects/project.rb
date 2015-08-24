#
# The MIT License (MIT)
#
# Copyright (c) 2014 Evgeny Shurakov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

module Locca
    class Project
        attr_reader :dir
        attr_reader :base_lang

        def initialize(dir, config)
            @dir = dir
            @config = config
                        
            @base_lang = config['base_lang']
        end

        def config_value_for_key(key)
            return @config[key]
        end

        def prevent_sync_without_comments?
            value = @config['prevent_sync_without_comments']
            if value == true ||
                value == 1
                return true
            else
                return false
            end
        end

        def langs
            # implement in subclass
        end

        def collection_names
            # implement in subclass 
        end

        def full_collection_name(collection_name)
           # implement in subclass
        end

        def path_for_collection(collection_name, lang)
            # implement in subclass
        end

        def collection_builder
            # implement in subclass
        end

        def collection_writer
            # implement in subclass
        end

        def collections_generator
            # implement in subclass
        end

        def one_sky_file_format
            # implement in subclass
        end

        def name
            return ""
        end

    end
end