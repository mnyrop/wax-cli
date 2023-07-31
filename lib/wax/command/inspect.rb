# frozen_string_literal: true

require_relative 'base'

module Wax
  module Command
    class Inspect < Base
      desc 'config', 'Inspect the wax site configuration'
      def config
        puts 'inspecting the wax site configuration'
      end

      desc 'collection NAME', 'Inspect the wax collection named NAME'
      def collection(name)
        puts "inspecting the '#{name}' collection"
      end
    end
  end
end
