#
# The MIT License (MIT)
#
# Copyright (c) 2015 Evgeny Shurakov
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

require_relative 'project'

module Locca
    class XcodeProject < Project
        attr_reader :code_dir

        def initialize(dir, config)
        	super(dir, config)
            @code_dir = File.join(dir, config['code_dir'])
        end

        def langs
            result = Set.new()
            Dir.glob(File.join(@lang_dir, '*.lproj')) do |filepath|
                result.add(File.basename(filepath, '.lproj'))
            end

            return result
        end

        def collection_names
            result = Set.new()
            Dir.glob(File.join(@lang_dir, "#{@base_lang}.lproj", '*.strings')) do |filepath|
                result.add(File.basename(filepath, '.strings'))
            end

            return result 
        end

        def full_collection_name(collection_name)
            return "#{collection_name}.strings"
        end

        def path_for_collection(collection_name, lang)
            return File.join(@lang_dir, "#{lang}.lproj", "#{collection_name}.strings")
        end

		def collection_builder()
            parser = Babelyoda::StringsParser.new(Babelyoda::StringsLexer.new())
            return CollectionBuilder.new(File, parser) 
        end

        def collection_writer()
            return CollectionWriter.new(File, CollectionItemDefaultFormatter.new())
        end

        def collections_generator()
            return CollectionsGenerator.new(self, Genstrings.new(), collection_builder())
        end

        def one_sky_file_format
            return "IOS_STRINGS"
        end

    end
end
