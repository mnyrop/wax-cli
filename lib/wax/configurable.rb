# frozen_string_literal: true

require 'json'

module Wax
  module Configurable
    def load(config)
      return config if config.is_a? Hash
      return read_hash(config) if config.is_a? String

      {}
    end

    def read_hash(yaml_file)
      raise Wax::FileNotFoundError, "Could not find expected config file #{yaml_file}. Are you in the right directory?" unless File.file? yaml_file
      raise Wax::InvalidFileError, "Provided config file #{File.basename(yaml_file)} does not have expected format .yml or .yaml" unless %w[.yml .yaml].include? File.extname yaml_file

      Wax::Utils.read_yaml yaml_file
    end
  end
end
