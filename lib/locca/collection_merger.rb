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
    class CollectionMerger
        ACTION_ADD              = (1 << 0)
        ACTION_DELETE           = (1 << 1)
        ACTION_UPDATE           = (1 << 2)
        ACTION_UPDATE_COMMENTS  = (1 << 3)
        
        def merge(src_collection, dst_collection, actions = (ACTION_ADD | ACTION_DELETE))
            if not src_collection or not dst_collection
                raise ArgumentError, 'Source and Destination Collections should be set'
            end

            dst_keys = nil
            if (actions & ACTION_DELETE) != 0
                dst_keys = dst_collection.all_keys
            end

            src_collection.each do |src_item|
                dst_item = dst_collection.item_for_key(src_item.key)

                if (actions & ACTION_ADD) != 0 && !dst_item
                    dst_collection.add_item(src_item.dup)
                elsif (actions & ACTION_UPDATE) != 0 && dst_item
                    dst_collection.add_item(src_item.dup)
                elsif (actions & ACTION_UPDATE_COMMENTS) != 0 && dst_item
                    item = CollectionItem.new(dst_item.key, dst_item.value, src_item.comment)
                    dst_collection.add_item(item)
                end

                if dst_keys
                    dst_keys.delete(src_item.key)
                end
            end

            if dst_keys
                dst_keys.each do |key|
                    dst_collection.remove_item_for_key(key)
                end
            end
        end

    end
end