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
require_relative 'xcode_project'

module Locca
    class ProjectNotFoundError < RuntimeError
    end

    class ConfigNotFoundError < RuntimeError
    end

    class ConfigNotValidError < RuntimeError
    end

    class ProjectFactory

        def initialize(project_dir_locator, config_reader)
            @project_dir_locator = project_dir_locator
            @config_reader = config_reader
        end

        def new_project(project_dir)
            project_dir = @project_dir_locator.locate(project_dir)
            if not project_dir
                raise ProjectNotFoundError, 'Can\'t find .locca dir (also checked parent dirs)'
            end

            config = @config_reader.read(@project_dir_locator.config_path(project_dir))
            if not config
                raise ConfigNotFoundError, 'Can\'t find .locca/config'
            end

            if Dir.glob("#{project_dir}/**/AndroidManifest.xml").length > 0
                return AndroidProject.new(project_dir, config)
            else
                return XcodeProject.new(project_dir, config)
            end
                        
        end

    end
end