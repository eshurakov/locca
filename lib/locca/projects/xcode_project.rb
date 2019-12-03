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

require 'xcodeproj'
require_relative 'project'

module Locca
    class XcodeProject < Project
        attr_reader :langs

        def initialize(dir, xcode_target, config)
        	super(dir, config)
            @xcode_target = xcode_target

            @files = Array.new()
            @langs = Set.new()

            @xcode_target.resources_build_phase.files_references.each { |file|  
                if file.display_name.end_with?(".strings") && file.is_a?(Xcodeproj::Project::Object::PBXVariantGroup)
                    @files.push(file)
                    if file.display_name == "Localizable.strings"
                        file.files.each { |variant_file|  
                            @langs.add(variant_file.name)
                        }
                    end
                end
            }
        end

        def name
            return @xcode_target.name
        end

        def collection_names
            result = Set.new()
            @files.each { |file|  
                result.add(File.basename(file.display_name, '.strings'))
            }

            return result 
        end

        def full_collection_name(collection_name)
            return "#{collection_name}.strings"
        end

        def path_for_collection(collection_name, lang)
            collection_name = "#{collection_name}.strings"
            @files.each { |file|  
                if file.display_name == collection_name
                    file.files.each { |variant_file|  
                        if variant_file.name == lang
                            return variant_file.real_path
                        end
                    }
                end
            }

            return nil
        end

		def collection_builder()
            parser = Babelyoda::StringsParser.new(Babelyoda::StringsLexer.new())
            return CollectionBuilder.new(File, parser) 
        end

        def collection_writer()
            return CollectionWriter.new(File, CollectionItemDefaultFormatter.new())
        end

        def collections_generator()
            source_files = Array.new()
            @xcode_target.source_build_phase.files_references.each { |file| 
                if !file.path.nil?
                    source_files.push(file.real_path.to_s)
                end
            }
            return CollectionsGenerator.new(source_files, Genstrings.new(), collection_builder())
        end

        def one_sky_file_format
            return "IOS_STRINGS"
        end

    end
end
