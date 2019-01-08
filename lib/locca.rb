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

require 'locca/version'

require 'locca/projects/project_dir_locator'
require 'locca/projects/project_factory'
require 'locca/projects/project'
require 'locca/projects/xcode_project'
require 'locca/projects/android_project'

require 'locca/config_reader'
require 'locca/config_validator'

require 'locca/actions/audit_action'
require 'locca/actions/build_action'
require 'locca/actions/merge_action'
require 'locca/actions/onesky_sync_action'
require 'locca/actions/translate_action'

require 'locca/sync/onesky'

require 'locca/collections_generator'
require 'locca/collection_merger'
require 'locca/collection_builder'
require 'locca/collection_writer'
require 'locca/collection_item_condensed_formatter'
require 'locca/collection_item_default_formatter'

require 'locca/android_collection_writer'
require 'locca/android_collections_generator'
require 'locca/android_strings_parser'

require 'locca/genstrings'

require 'babelyoda/strings_lexer'
require 'babelyoda/strings_parser'

module Locca
    class Locca
        def audit(project)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end

            action = AuditAction.new(project, project.collection_builder(), project.collections_generator())
            failed_audit_results = action.execute()

            failed_audit_results.each do |audit_result|
                puts()
                puts(">>> #{project.name}/#{audit_result.lang}/#{audit_result.collection_name}")
                unless audit_result.missing_keys.empty?
                    puts("Missing Keys:")
                    audit_result.missing_keys.each do |key|
                        puts("- #{key}")
                    end
                end

                unless audit_result.extra_keys.empty?
                    puts("Extra Keys:")
                    audit_result.extra_keys.each do |key|
                        puts("- #{key}")
                    end
                end

                unless audit_result.untranslated_keys.empty?
                    puts("Untranslated:")
                    audit_result.untranslated_keys.each do |key|
                        puts("- #{key}")
                    end
                end
            end

            return failed_audit_results.empty?
        end

        def build(project)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end

            build_action(project).execute()
        end

        def merge(src_file, dst_file)
            action = MergeAction.new(src_file, dst_file, collection_builder(), collection_writer(), collection_merger())
            action.execute()
        end

        def sync(project, prune_missing_strings = false)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end
            
            one_sky_action(project).sync(prune_missing_strings)
        end

        def fetch(project)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end
            
            one_sky_action(project).fetch()
        end

        def translate(project, lang = nil)
            if not project
                raise 'Can\'t initialize Locca with nil project'
            end

            if not lang
                lang = project.base_lang
            end

            action = TranslateAction.new(project, lang, project.collection_builder(), project.collection_writer(), collection_merger())
            action.execute()
        end

        def build_action(project)
            return BuildAction.new(project, project.collection_builder(), project.collection_writer(), project.collections_generator(), collection_merger())
        end

        def one_sky_action(project)
            onesky = Onesky.new(project.config_value_for_key('onesky_project_id'), project.config_value_for_key('onesky_public_key'), project.config_value_for_key('onesky_secret_key'))

            return OneskySyncAction.new(project, onesky, project.collection_builder(), project.collection_writer(), project.collections_generator(), collection_merger())
        end

        def collection_merger()
            return CollectionMerger.new()
        end
    end
end