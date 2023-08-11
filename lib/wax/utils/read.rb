# frozen_string_literal: true

module Wax
  module Utils
    module Read
      def self.records_file(file)
        raise Wax::FileNotFoundError unless File.file? file

        case File.extname file
        when '.csv'
          Utils::Read.csv file
        when '.json'
          Utils::Read.json file
        when /\.ya?ml/
          Utils::Read.yaml file
        else
          raise Wax::InvalidFileError, "Expected file #{file} to have format .csv, .json, or .yml"
        end
      end

      def self.csv(file)
        CSV.read(file, headers: true).map(&:to_hash)
      rescue StandardError
        raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid CSV?"
      end

      def self.json(file)
        JSON.parse File.read(file)
      rescue StandardError
        raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid JSON?"
      end

      def self.yaml(file)
        YAML.load_file file
      rescue StandardError
        raise Wax::InvalidFileError, "Could not open file #{file}. Is it valid YAML?"
      end

      def self.hash(data)
        case data
        when Hash
          data
        when String
          raise Wax::FileNotFoundError, "Could not find expected config file #{data}. Are you in the right directory?" unless File.file? data
          raise Wax::InvalidFileError, "Provided config file #{File.basename(data)} does not have expected format .yml or .yaml" unless %w[.yml .yaml].include? File.extname data

          Utils::Read.yaml data
        else
          warn Rainbow("Ignoring provided custom config with invalid type #{data.class}").orange
          {}
        end
      end
    end
  end
end
