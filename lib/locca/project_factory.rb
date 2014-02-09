require_relative 'project'

module Locca
    class ProjectNotFoundError < RuntimeError
    end

    class ConfigNotFoundError < RuntimeError
    end

    class ConfigNotValidError < RuntimeError
    end

    class ProjectFactory

        def initialize(project_dir_locator, config_reader, config_validator)
            @project_dir_locator = project_dir_locator
            @config_reader = config_reader
            @config_validator = config_validator
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

            if not @config_validator.validate(config)
               raise ConfigNotValidError, 'Config .locca/config is not valid' 
            end

            return Project.new(project_dir, config)
        end

    end
end