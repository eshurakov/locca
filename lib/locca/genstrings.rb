require 'open3'
require 'fileutils'
require 'tmpdir'

module Locca
    class Genstrings
        def generate(code_dir)
            Dir.mktmpdir do |tmp_dir|
                command = "find #{code_dir} -iname \"*.m\" -or -iname \"*.mm\" -or -iname \"*.c\" | xargs genstrings -o '#{tmp_dir}'"
                stdout, stderr, status = Open3.capture3(command)

                STDERR.puts(stderr)

                if status.success?
                    Dir.glob(File.join(tmp_dir, '*.strings')) do |filename|
                        yield(filename)
                    end
                else
                    raise "genstrings failed"
                end
            end
        end
    end
end
