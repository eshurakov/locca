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
require_relative 'collection'
require_relative 'collection_item'

module Locca
    class CollectionBuilder
        def initialize(file_manager, parser)
            @file_manager = file_manager
            @parser = parser
        end

        def collection_at_path(path)
            collection = nil

            @file_manager.open(path, 'rb:BOM|UTF-8:UTF-8') do |file|
                collection = collection_from_datastring(file.read())
                collection.name = File.basename(path, File.extname(path))
            end

            return collection
        end

        def collection_from_datastring(datastring)
            collection = Collection.new()
            @parser.parse(datastring) do |key, value, comment|
                collection.add_item(CollectionItem.new(key, value, comment))
            end
            return collection
        end
    end
end