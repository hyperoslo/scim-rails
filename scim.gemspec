$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'scim/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'scim-rails'
  s.version     = SCIM::VERSION
  s.authors     = ['Felipe Espinoza']
  s.email       = ['felipe@hyper.no']
  s.homepage    = 'https://github.com/hyperoslo/scim-rails'
  s.summary     = 'Ruby on Rails implementation the SCIM protocol'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc'
  ]

  s.add_dependency 'rails', '~> 4.2.6'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec_api_documentation'
end
