# File: Rakefile
# Time-stamp: <2018-12-13 11:06:32>
# Copyright (C) 2018 Pierre Lecocq
# Description: LocalStore rake tasks

task default: :spec

# Spec

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec

# Yard

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end
