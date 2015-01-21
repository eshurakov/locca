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

require 'nokogiri'

module Locca

	class AndroidCollectionWriter

        def initialize(file_manager)
            @file_manager = file_manager
        end

        def write_to_path(collection, filepath)
            if not filepath
                raise ArgumentException, 'filepath can\'t be nil'
            end

            FileUtils.mkdir_p(@file_manager.dirname(filepath))


            document = Nokogiri::XML("")
            document.encoding = "UTF-8"

            resources = Nokogiri::XML::Node.new('resources', document)

            collection.sorted_each do |item|
				if item.comment
					resources.add_child(Nokogiri::XML::Comment.new(document, " #{item.comment} "))
				end

				string = Nokogiri::XML::Node.new('string', document)
				string["name"] = item.key
				string.content = item.value
				resources.add_child(string)
	        end

            document.root = resources

            @file_manager.open(filepath, "w") do |io|
                io << document.to_xml
            end
        end
    end

end
