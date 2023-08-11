# frozen_string_literal: true

require_relative 'builder'
require_relative 'build_strategies'
require_relative 'builders/iiif_builder'
require_relative 'builders/page_builder'
require_relative 'builders/simple_image_builder'

module Wax
  class Factory
    def initialize(strategy, collection_config, opts)
      @strategy           = strategy
      @collection_config  = collection_config
      @opts               = opts
    end

    def builder
      case @strategy
      when 'iiif'
        Wax::IIIFBuilder.new @collection_config, @opts
      when 'simple_images'
        Wax::SimpleImageBuilder.new @collection_config, @opts
      when 'pages'
        Wax::PageBuilder.new @collection_config, @opts
      else
        raise Wax::Error, "Builder was initialized with invalid strategy \"#{@strategy}\". Must be one of #{BuildStrategies.valid}"
      end
    end
  end
end
