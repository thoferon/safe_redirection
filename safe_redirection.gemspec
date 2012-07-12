$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "safe_redirection/constants"

Gem::Specification.new do |s|
  s.name = "safe_redirection"
  s.version = SafeRedirection::VERSION
  s.authors = ["Thomas Feron"]
  s.description = "A small library for sanitization of URLs for redirections in Rails"
  s.summary = "safe_redirection-#{s.version}"
  s.email = "tho.feron@gmail.com"

  s.platform = Gem::Platform::RUBY

  s.add_development_dependency "rake"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec"

  s.files = `git ls-files`.split("\n").reject { |path| path =~ /\.gitignore$/ }
  s.test_files = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_path = "lib"
end
