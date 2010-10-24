Gem::Specification.new do |gem|
  gem.name    = 'rodent'
  gem.version = '0.1'
  gem.date    = Time.now.to_s

  gem.summary = "Scurries inside ODT documents."
  gem.description = "
    rODent knows how to retrieve stuff from ODT documents and little else.
  "

  gem.authors  = ['Chris Cacciatore']
  gem.homepage = 'http://github.com/user/rODenT'

  gem.add_dependency('nokogiri')
  gem.add_dependency('rubyzip')
  gem.add_development_dependency('rspec', [">= 2.0.0"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['{lib,test,spec}/**/*', 'README*'] & `git ls-files -z`.split("\0")
end