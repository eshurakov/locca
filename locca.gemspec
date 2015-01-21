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
  s.add_development_dependency('minitest')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('rest-client')
  s.add_runtime_dependency('nokogiri')
end
