module SafeRedirection
  VERSION = '0.0.2'

  class Error < StandardError; end
  class SanitizationCancelled < SafeRedirection::Error; end
end
