require File.join([File.dirname(__FILE__),'lib','locca','version.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'locca'
  s.version = Locca::VERSION
  s.author = 'Shurakov Evgeny'
  s.email = 'inbox@shurakov.name'
  s.homepage = 'https://github.com/eshurakov/locca'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'
  s.summary = 'Application localization kit'
  s.files = Dir.glob("{bin,lib}/**/*")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.bindir = 'bin'
  s.executables << 'locca'
  s.add_development_dependency('minitest', '~> 5.0', '>= 5.0')
  s.add_development_dependency('mocha', '~> 1.5', '>= 1.5')
  s.add_development_dependency('rake', '~> 12.0', '>= 12.0')
  s.add_development_dependency('rdoc', '~> 6.0', '>= 6.0')
  s.add_runtime_dependency('gli', '~> 2.0', '>= 2.0')
  s.add_runtime_dependency('rest-client', '~> 2.0', '>= 2.0')
  s.add_runtime_dependency('nokogiri', '~> 1.8', '>= 1.8')
  s.add_runtime_dependency('xcodeproj', '~> 1.5', '>= 1.5')
  s.add_runtime_dependency('json', '~> 2.1', '>= 2.1')
end
