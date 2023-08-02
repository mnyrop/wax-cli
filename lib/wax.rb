# frozen_string_literal: true

require 'rainbow'

require_relative 'wax/cli'
require_relative 'wax/collection'
require_relative 'wax/error'
require_relative 'wax/project'
require_relative 'wax/utils'
require_relative 'wax/version'

require_relative 'wax/loaders/records_loader'

module Wax
  module Validate
    VALID_BUILD_STRATEGIES = %w[simple_images iiif pages].freeze

    def self.build_strategies(list)
      list.find_all { |key| VALID_BUILD_STRATEGIES.include? key }
    end
  end
end
