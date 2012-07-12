$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'safe_redirection'

class MyResolver < SafeRedirection::Resolvers::Resolver
  def recognize_path(path, options = {})
    if path =~ /^special/
      "http://my.app.tld/special_page"
    else
      raise 'Not found'
    end
  end
end

resolver = MyResolver.new
my_sanitizer = SafeRedirection::Sanitizer.new(resolver, 'http://my.app.tld/root/path/', 'http://my.app.tld/root/path/default_url')

puts my_sanitizer.safe_url_for('http://www.outside.tld/some/path')
puts my_sanitizer.safe_url_for('http://my.app.tld/root/path/special/subpath')
puts my_sanitizer.safe_url_for('ftp://my.app.tld/root/path/special/subpath')
puts my_sanitizer.safe_url_for('http://my.app.tld2/root/path/special/subpath')
