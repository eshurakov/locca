# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','locca','version.rb'])
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
  lib/babelyoda/strings_lexer.rb
  lib/babelyoda/strings_parser.rb
	lib/locca/config.rb
  lib/locca/project.rb
  lib/locca/genstrings.rb
  lib/locca/keyset.rb
  lib/locca/strings_collection.rb
  lib/locca/strings_item.rb
  lib/locca/strings_merger.rb
  lib/locca/strings_serialization.rb
  lib/locca/version.rb
	lib/locca.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','Locca.rdoc']
  s.rdoc_options << '--title' << 'Locca' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'locca'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
end
