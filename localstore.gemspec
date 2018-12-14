require_relative 'lib/localstore'

Gem::Specification.new do |s|
  s.name        = LocalStore::NAME
  s.version     = LocalStore::VERSION
  s.date        = '2018-12-13'
  s.summary     = 'Local data store'
  s.description = 'Provides a class level local data store with namespaces support'
  s.authors     = ['Pierre Lecocq']
  s.email       = 'pierre.lecocq@gmail.com'
  s.files       = Dir.glob('{lib,spec}/**/*') + %w[Rakefile]
  s.homepage    = 'https://github.com/pierre-lecocq/localstore'
  s.license     = 'MIT'
end
