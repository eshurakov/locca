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

require 'locca/audit_result'

module Locca
    class AuditAction
        def initialize(project, collection_builder, collections_generator)
            @project = project
            @collections_generator = collections_generator
            @collection_builder = collection_builder
        end

        def execute()
            generated_collections = @collections_generator.generate()

            audit_ignore = @project.config_value_for_key('audit_ignore')
            failed_audit_results = []

            @project.collection_names().each do |collection_name|
                keys_to_ignore = []
                if audit_ignore != nil && audit_ignore.key?(collection_name)
                    keys_to_ignore = audit_ignore[collection_name]
                end

                @project.langs().each do |lang|
                    collection_path = @project.path_for_collection(collection_name, lang)
                    collection = @collection_builder.collection_at_path(collection_path)
                    
                    audit_result = AuditResult.new(collection_name, lang)

                    generated_collections.each do |generated_collection|
                        if generated_collection.name == collection.name
                            generated_collection_keys = generated_collection.all_keys().to_set
                            collection_keys = collection.all_keys().to_set

                            audit_result.missing_keys = (generated_collection_keys - collection_keys).to_a
                            audit_result.extra_keys = (collection_keys - generated_collection_keys).to_a
                        end
                    end

                    collection.sorted_each do |item|
                        if item.translated? || keys_to_ignore.include?(item.key) || audit_result.extra_keys.include?(item.key)
                            next
                        end

                        audit_result.add_untranslated_key(item.key)
                    end

                    unless audit_result.passed?
                        failed_audit_results.push(audit_result)
                    end
                end
            end

            return failed_audit_results
        end
    end
end