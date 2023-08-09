# frozen_string_literal: true

module Wax
  class Error < RuntimeError
    def initialize(msg = '', extra = '')
      puts Rainbow(self).red
      puts Rainbow(msg).magenta
      puts extra unless extra.empty?

      super('')
    end
  end

  class CollectionError < Error; end
  class ConfigError < Error; end
  class FileNotFoundError < Error; end
  class InvalidFileError < Error; end
end
