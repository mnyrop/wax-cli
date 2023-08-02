# frozen_string_literal: true

require 'csv'
require 'json'
require 'yaml'

module Wax
  module Utils
    # def self.deep_struct(hash)
    #   JSON.parse hash.to_json, object_class: OpenStruct
    # end

    def self.absolute_path(path)
      wd = ENV['WORKING_DIR'] || Dir.pwd
      return path if path.start_with? wd

      File.join wd, path
    end

    def self.read_csv(file)
      CSV.read(file, headers: true).map(&:to_hash)
    rescue StandardError
      raise Error::InvalidFileError, "Could not open file #{file}. Is it valid CSV?"
    end

    def self.read_json(file)
      JSON.parse File.read(file)
    rescue StandardError
      raise Error::InvalidFileError, "Could not open file #{file}. Is it valid JSON?"
    end

    def self.read_yaml(file)
      YAML.load_file file
    rescue StandardError
      raise Error::InvalidFileError, "Could not open file #{file}. Is it valid YAML?"
    end
  end
end
