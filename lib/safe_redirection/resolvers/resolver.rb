module SafeRedirection
  module Resolvers
    class Resolver
      attr_accessor :resolver

      def initialize(resolver = nil)
        @resolver = resolver
      end

      def recognize_path(*args)
        raise NotImplementedError
      end
    end
  end
end
