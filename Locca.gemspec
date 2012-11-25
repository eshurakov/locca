# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','Locca','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'Locca'
  s.version = Locca::VERSION
  s.author = 'Shurakov Evgeny'
  s.email = 'inbox@shurakov.name'
  s.homepage = 'http://shurakov.name'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Application localization kit'
# Add your other files here if you make them
  s.files = %w(
	bin/locca
  lib/Babelyoda/strings_lexer.rb
  lib/Babelyoda/strings_parser.rb
	lib/Locca/Config.rb
  lib/Locca/Genstrings.rb
  lib/Locca/Keyset.rb
  lib/Locca/Strings.rb
  lib/Locca/StringsMerger.rb
  lib/Locca/StringsSerialization.rb
  lib/Locca/version.rb
	lib/Locca.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','Locca.rdoc']
  s.rdoc_options << '--title' << 'Locca' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'locca'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.0')
  s.add_runtime_dependency('rchardet19', '1.3.5')
end
