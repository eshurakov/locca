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

# 1. Fetch translations from one sky app
# 2. Merge translated values with local translations
# 3. Run 'build' action
# 4. Upload base language translations to one sky app

require 'locca/collection_merger'

module Locca
    class OneskySyncAction
        def initialize(project, onesky, collection_builder, collection_writer, collections_generator, collection_merger)
            @project = project
            @collections_generator = collections_generator
            @collection_merger = collection_merger
            @collection_builder = collection_builder
            @collection_writer = collection_writer
            @onesky = onesky

            @langs = @project.langs()
            @generated_collections = @collections_generator.generate()
        end 

        def fetch()
            # 1
            @generated_collections.each do |generated_collection|
                @langs.each do |lang|
                    print "[*] fetch: #{lang}/#{generated_collection.name}\n"
                    data = @onesky.fetch_translations(lang, @project.full_collection_name(generated_collection.name))
                    fetched_collection = @collection_builder.collection_from_datastring(data)

                    local_collection_path = @project.path_for_collection(generated_collection.name, lang)
                    local_collection = @collection_builder.collection_at_path(local_collection_path)

                    # 2
                    print "[*] merge: onesky -> #{lang}/#{generated_collection.name}\n"
                    @collection_merger.merge(fetched_collection, local_collection, CollectionMerger::ACTION_ADD | CollectionMerger::ACTION_UPDATE)
                    @collection_writer.write_to_path(local_collection, local_collection_path)
                end
            end
        end

        def sync(prune_missing_strings = false)
            fetch()

            # 3
            @generated_collections.each do |generated_collection|
                @langs.each do |lang|
                    print "[*] merge: code -> #{lang}/#{generated_collection.name}\n"

                    local_collection_path = @project.path_for_collection(generated_collection.name, lang)
                    local_collection = @collection_builder.collection_at_path(local_collection_path)
                    @collection_merger.merge(generated_collection, local_collection, (CollectionMerger::ACTION_ADD | CollectionMerger::ACTION_DELETE | CollectionMerger::ACTION_UPDATE_COMMENTS))

                    @collection_writer.write_to_path(local_collection, local_collection_path)
                end
            end

            if @project.prevent_sync_without_comments?                    
                lang = @project.base_lang
                @generated_collections.each do |generated_collection|
                    print "[*] check: #{lang}/#{generated_collection.name}\n"

                    local_collection_path = @project.path_for_collection(generated_collection.name, lang)
                    local_collection = @collection_builder.collection_at_path(local_collection_path)                

                    keys = local_collection.keys_without_comments
                    if keys.length > 0
                        raise "Keys without comments:\n" + keys.join("\n")
                    end
                end
            end

            # 4
            @generated_collections.each do |generated_collection|
                print "[*] upload: #{@project.base_lang}/#{generated_collection.name}\n"
                collection_path = @project.path_for_collection(generated_collection.name, @project.base_lang())
                @onesky.upload_file(collection_path, @project.one_sky_file_format, prune_missing_strings)
            end
        end
    end
end