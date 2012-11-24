# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','Locca','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'Locca'
  s.version = Locca::VERSION
  s.author = 'Shurakov Evgeny'
  s.email = 'inbox@shurakov.name'
  s.homepage = 'http://shurakov.name'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
	bin/Locca
	lib/Locca/version.rb
	lib/Locca.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','Locca.rdoc']
  s.rdoc_options << '--title' << 'Locca' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'Locca'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.0')
  s.add_runtime_dependency('rchardet19', '1.3.5')
end
