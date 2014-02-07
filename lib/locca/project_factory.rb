require_relative 'project'

module Locca
    class ProjectFactory

        def initialize(project_dir_locator, config_reader)
            @project_dir_locator = project_dir_locator
            @config_reader = config_reader
        end

        def new_project(project_dir)
            project_dir = @project_dir_locator.locate(project_dir)
            if project_dir
                config = @config_reader.read(@project_dir_locator.config_path(project_dir))
                return Project.new(project_dir, config)
            else
                return nil
            end
        end

    end
end