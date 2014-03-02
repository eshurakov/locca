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

require 'locca/collection_merger'

module Locca
    class MergeAction
        def initialize(src_file, dst_file, collection_builder, collection_merger)
            @src_file = src_file
            @dst_file = dst_file
            @collection_merger = collection_merger
            @collection_builder = collection_builder
        end

        def execute()
        	src_collection = @collection_builder.collection_at_path(@src_file)
        	dst_collection = @collection_builder.collection_at_path(@dst_file)
        	@collection_merger.merge(src_collection, dst_collection, (CollectionMerger::ACTION_ADD | CollectionMerger::ACTION_UPDATE))
			dst_collection.write_to(@dst_file)
        end
    end
end