# frozen_string_literal: true

require 'rainbow'

require_relative 'base'

module Wax
  module Command
    class Inspect < Base
      desc 'config', 'Inspect the wax site configuration'
      def config
        puts Rainbow('inspecting the wax site configuration').cyan
      end

      desc 'collection NAME', 'Inspect the wax collection named NAME'
      def collection(name)
        puts Rainbow("inspecting the '#{name}' collection").cyan
      end
    end
  end
end
