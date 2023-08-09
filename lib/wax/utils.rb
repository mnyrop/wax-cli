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

    def self.safe_join(*paths)
      File.join(*paths).reverse.chomp('/').reverse.chomp('/')
    end

    def self.read_records_file(file)
      raise Wax::FileNotFoundError unless File.file? file

      case File.extname file
      when '.csv'
        Wax::Utils.read_csv file
      when '.json'
        Wax::Utils.read_json file
      when /\.ya?ml/
        Wax::Utils.read_yaml file
      else
        raise Wax::InvalidFileError, "Expected file #{file} to have format .csv, .json, or .yml"
      end
    end

    def self.read_csv(file)
      CSV.read(file, headers: true).map(&:to_hash)
    rescue StandardError
      raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid CSV?"
    end

    def self.read_json(file)
      JSON.parse File.read(file)
    rescue StandardError
      raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid JSON?"
    end

    def self.read_yaml(file)
      YAML.load_file file
    rescue StandardError
      raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid YAML?"
    end

    def self.read_hash(data)
      case data
      when Hash
        data
      when String
        raise Wax::FileNotFoundError, "Could not find expected config file #{data}. Are you in the right directory?" unless File.file? data
        raise Wax::InvalidFileError, "Provided config file #{File.basename(data)} does not have expected format .yml or .yaml" unless %w[.yml .yaml].include? File.extname data

        Wax::Utils.read_yaml data
      else
        warn Rainbow("Ignoring provided custom config with invalid type #{data.class}").orange
        {}
      end
    end
  end
end
