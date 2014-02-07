
module Locca
    class ProjectDirLocator

        def locate(dir)
            if not File.directory?(dir)
                return nil
            end

            while dir
                if File.directory?(File.join(dir, ".locca"))
                    return dir
                end
                
                new_dir = File.expand_path('..', dir)
                if new_dir == dir
                    break
                end
                dir = new_dir
            end

            return nil
        end

        def config_path(project_dir)
            return File.join(project_dir, '.locca/config')
        end

    end
end