# frozen_string_literal: true

module Wax
  class Error < RuntimeError
    def initialize(msg = '')
      puts Rainbow(self).red
      puts Rainbow(msg).magenta

      super('')
    end
  end

  class ConfigError < Error; end
  class FileNotFoundError < Error; end
  class InvalidFileError < Error; end
end
