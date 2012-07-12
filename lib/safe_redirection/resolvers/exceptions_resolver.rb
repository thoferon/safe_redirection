module SafeRedirection
  module Resolvers
    class ExceptionsResolver < Resolver
      attr_accessor :legitimate_urls, :legitimate_base_urls

      def initialize(*args)
        super(*args)
        @legitimate_urls = []
        @legitimate_base_urls = []
      end

      def recognize_path(path, options = {})
        if self.legitimate_urls.include?(path) ||
            self.legitimate_base_urls.any? { |base| path.start_with? base }
          path
        else
          resolver.recognize_path path, options
        end
      end
    end
  end
end
