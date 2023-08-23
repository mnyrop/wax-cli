# frozen_string_literal: true

require 'rainbow'

module Wax
  module Utils
    module Print
      def self.checkmark
        sleep(0.25)
        Rainbow("\t✓ ").green
      end

      def self.warning
        sleep(0.25)
        Rainbow("\t✗ ").magenta
      end

      def self.meh
        sleep(0.25)
        Rainbow("\t~ ").tan
      end
    end
  end
end
