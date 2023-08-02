# frozen_string_literal: true

require_relative 'base'

module Wax
  module Commands
    class Lint < Base
      desc 'collection NAME', 'Lint the wax collection named NAME'
      def collection(name)
        puts "linting the '#{name}' collection"
      end

      desc 'collections', 'Lint all available wax collections'
      def collections
        puts 'linting all the collections'
      end
    end
  end
end
