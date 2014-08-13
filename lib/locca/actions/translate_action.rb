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

require 'tempfile'
require 'open3'

module Locca
    class TranslateAction
        def initialize(project, lang, collection_builder, collection_writer, collection_merger)
            @project = project
            @lang = lang
            @collection_merger = collection_merger
            @collection_builder = collection_builder
            @collection_writer = collection_writer
        end

        def execute()
        	editor = ENV['EDITOR']
			if !editor
				raise ArgumentError, 'EDITOR variable should be defined'
			end

			@project.collection_names().each do |collection_name|
				collection_path = @project.path_for_collection(collection_name, @lang)
                collection = @collection_builder.collection_at_path(collection_path)

				tmpCollection = Collection.new()

				collection.sorted_each do |item|
                    if item.translated?
						next
					end

					tmpCollection.add_item(item)
                end

                if tmpCollection.count == 0
                	next
                end

                tmpFile = Tempfile.new("#{collection_name}.#{@lang}.tmp")

                @collection_writer.write_to_path(tmpCollection, tmpFile.path)
                command = "#{editor} #{tmpFile.path}"
				stdout,stderr,status = Open3.capture3(command)
				if status.success?
					translated_collection = @collection_builder.collection_at_path(tmpFile.path)
					@collection_merger.merge(translated_collection, collection, (CollectionMerger::ACTION_UPDATE))
                    @collection_writer.write_to_path(collection, collection_path)
				end
				tmpFile.close
				tmpFile.unlink
			end
        end
	end
end
