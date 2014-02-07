
require_relative 'config'

module Locca
	class Project
		attr_reader :config
		attr_reader :dir
		attr_reader :strings_dir

		def self.project_with_dir(dir, strings_dir)
			if dir and not File.directory?(dir)
				return nil
			end

			if not dir
				dir = Dir.pwd
			end

			while dir
				result = Dir.glob(File.join(dir, "*.xcodeproj"))
				if result && result.count > 0
					return Project.new(dir, strings_dir)
				end
				new_dir = File.expand_path('..', dir)
				if new_dir == dir
					break
				end
				dir = new_dir
			end

			return nil
		end

		def initialize(dir, strings_dir)
			@dir = dir
			@strings_dir = strings_dir
			@config = Config.new()
		end
	end
end