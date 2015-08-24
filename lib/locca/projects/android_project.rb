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
    class AndroidProject < Project
        MAIN_COLLECTION_NAME = 'strings'

        attr_reader :lang_dir

        def initialize(dir, config)
        	super(dir, config)
            @lang_dir = File.join(dir, config['lang_dir'])
        end

        def name
            return "Android"
        end

        def langs
            result = Set.new()
            result.add(self.base_lang)

            Dir.glob(File.join(@lang_dir, 'values-*')) do |filepath|
                if (File.exist?(File.join(filepath, "#{MAIN_COLLECTION_NAME}.xml")))
                    result.add(File.basename(filepath).split('-', 2).last) 
                end
            end

            return result
        end

        def collection_names
            result = Set.new()
            result.add(MAIN_COLLECTION_NAME);
            return result 
        end

        def full_collection_name(collection_name)
            return "#{collection_name}.xml"
        end

        def path_for_collection(collection_name, lang)
        	if (lang == self.base_lang)
        		return File.join(@lang_dir, "values", "#{collection_name}.xml")
        	else
            	return File.join(@lang_dir, "values-#{lang}", "#{collection_name}.xml")
            end
        end

        def collection_builder()
            parser = AndroidStringsParser.new()
            return CollectionBuilder.new(File, parser) 
        end

        def collection_writer()
            return AndroidCollectionWriter.new(File)
        end

        def collections_generator()
        	return AndroidCollectionsGenerator.new(self, collection_builder())
        end

        def one_sky_file_format
            return "ANDROID_XML"
        end

    end
end
