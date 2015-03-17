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
    class Collection
        attr_accessor :name
        attr_accessor :lang

        def initialize(name = nil, lang = nil)
            @name = name 
            @lang = lang
            @items = {}
        end

        def add_item(item)
            if !item || !item.key
                raise ArgumentError, 'item or item.key is nil'
            end
            @items[item.key] = item
        end

        def remove_item_for_key(key)
            return @items.delete(key)
        end

        def item_for_key(key)
            return @items[key]
        end

        def has_key?(key)
            return @items.has_key?(key)
        end

        def all_keys
            return @items.keys
        end

        def keys_without_comments
            result = []
            @items.each do |key, item|
                if item.comment == nil || item.comment.strip.length == 0
                    result.push(key)
                end
            end
            return result
        end

        def translated?
            @items.each do |key, item|
                if !item.translated?
                    return false
                end
            end

            return true
        end

        def count
            return @items.count
        end

        def each
            @items.each do |key, item|
                yield(item)
            end
        end 

        def sorted_each
            sorted_keys = all_keys.sort(&:casecmp)
            sorted_keys.each do |key|
                yield(@items[key])
            end
        end

        def to_s ; "<#{self.class}: lang = #{lang}, name = #{name}>" ; end
    end
end