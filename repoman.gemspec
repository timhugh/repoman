# frozen_string_literal: true

require './lib/repoman/version'

Gem::Specification.new do |s|
  s.name          = 'repoman'
  s.version       = Repoman::VERSION
  s.date          = '2018-12-04'
  s.summary       = 'Repository manager'
  s.description   = 'For managing git repositories'
  s.authors       = ['Tim Heuett']
  s.email         = 'tim.heuett@gmail.com'
  s.files         = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }
  s.executables   = ['repoman']
  s.homepage      = ''
  s.require_paths = ['lib']
  s.license       = 'MIT'

  s.add_dependency 'colorize', '~> 0'
  s.add_dependency 'thor', '~> 0'
  s.add_dependency 'tty-table', '~> 0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
end
