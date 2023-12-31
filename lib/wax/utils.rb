# frozen_string_literal: true

require 'csv'
require 'json'
require 'vips'
require 'yaml'

require_relative 'utils/hash'
require_relative 'utils/image'
require_relative 'utils/path'
require_relative 'utils/print'
require_relative 'utils/read'

module Wax
  module Utils
    def self.padded_int(idx, max_idx)
      idx.to_s.rjust(Math.log10(max_idx).to_i + 1, '0')
    end

    def self.all_items?(items)
      items.is_a? Array and items.all? { |item| item.is_a? Wax::Item }
    end

    def self.jsonify_items(items)
      raise Wax::Error, 'Called jsonify_items but was not given expected array of Wax::Items', "Culprit: #{items.inspect}" unless all_items?(items)

      JSON.pretty_generate items.map(&:to_h)
    end

    def self.truncate(str, max)
      string = str.to_s
      string.length > max ? "#{string[0...max]}..." : string
    end

    def self.front_matter_string
      "---\n\n---\n"
    end

    def self.prepend_yaml_files(paths)
      paths.each do |path|
        filestring = File.read path
        next if filestring.start_with? front_matter_string

        File.open(path, 'w') do |file|
          file.puts front_matter_string
          file.puts filestring
        end
      end
    end
  end
end
