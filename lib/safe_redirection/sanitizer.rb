module SafeRedirection
  class Sanitizer
    attr_accessor :resolver, :base_url, :default_url

    def initialize(resolver, base_url, default_url)
      @resolver = resolver
      @base_url = base_url
      @default_url = default_url
    end

    def safe_url_for(redirect_url)
      uri = URI(redirect_url)
      path = relative_path(uri.path)

      if %w{http https}.include? uri.scheme
        resolver.recognize_path(path, :method => :get) rescue default_url
      else
        default_url
      end
    end

    def base_path
      URI(base_url).path
    end

    def relative_path(path)
      path.start_with?(base_path) ? path.sub(base_path, '') : path
    end
  end
end
