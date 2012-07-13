# SafeRedirection

SafeRedirection allows you to easily sanitize your URLs.

## Getting started

```ruby
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

my_sanitizer.safe_url_for 'http://www.outside.tld/some/path'
# => "http://my.app.tld/root/path/default_url"
my_sanitizer.safe_url_for 'http://my.app.tld/root/path/special/subpath'
# => "http://my.app.tld/special_page"
my_sanitizer.safe_url_for 'ftp://my.app.tld/root/path/special/subpath'
# => "http://my.app.tld/root/path/default_url"
my_sanitizer.safe_url_for 'http://my.app.tld2/root/path/special/subpath'
# => "http://my.app.tld/special_page"
```

Everything that responds to `recognize_path` could be a resolver and guess what! `ActionController::Routing::Routes` with Rails 2.x and `MyApplication::Application.routes` in Rails 3.x do respond to this method. It can therefore be used as a resolver in a code like this :

```ruby
resolver = SafeRedirection::Resolvers::ExceptionsResolver.new(MyApplication::Application.routes)
resolver.legitimate_base_urls << "http://www.outsite.tld/"
sanitizer = SafeRedirection::Sanitizer.new(resolver, 'http://my.app.tld/', 'http://my.app.tld/')

sanitizer.safe_url_for "http://my.app.tld/articles/2"
# => { :controller => "articles", :action => "show", :id => 2 }
sanitizer.safe_url_for "http://www.outside.tld/path"
# => "http://www.outside.tld/path"
sanitizer.safe_url_fo "http://www.outside.but_somewhere_else.com/"
# => "http://my.app.tld/"
```
