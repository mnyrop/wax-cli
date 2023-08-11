# frozen_string_literal: true

require 'thor'

module Wax
  module Commands
    class Base < Thor
      def self.subcommand_prefix
        str = name.gsub(/.*::/, '')
        str.gsub!(/^[A-Z]/) { |match| match[0].downcase }
        str.gsub!(/[A-Z]/)  { |match| "-#{match[0].downcase}" }
        str
      end
    end
  end
end
