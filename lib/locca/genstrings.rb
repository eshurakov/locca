require 'open3'
require 'fileutils'
require 'tmpdir'

module Locca
	class Genstrings

    def self.generate(src_dir)
			Dir.mktmpdir do |dir|
				command = "find #{src_dir} -iname \"*.m\" -or -iname \"*.mm\" -or -iname \"*.c\" | xargs genstrings -o '#{dir}'"
				stdout,stderr,status = Open3.capture3(command)

				STDERR.puts(stderr)

				if status.success?
					Dir.glob(File.join(dir, '*.strings')) do |filename|
						yield(filename)
					end
				else
					raise "genstrings failed"
				end
			end
		end
	end
end
