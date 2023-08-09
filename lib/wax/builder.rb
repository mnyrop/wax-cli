# frozen_string_literal: true

require_relative 'build_strategies'
require_relative 'builders/iiif_builder'
require_relative 'builders/page_builder'
require_relative 'builders/simple_image_builder'

module Wax
  # factory only
  class Builder
    def initialize(strategy)
      @strategy = strategy

      raise Wax::Error, "Builder was initialized with invalid strategy \"#{strategy}\". Must be one of #{BuildStrategies.valid}" unless valid?
    end

    def valid?
      BuildStrategies.valid.include? @strategy
    end

    def factory
      case @strategy
      when 'iiif'
        Wax::IIIFBuilder.new
      when 'simple_images'
        Wax::SimpleImageBuilder.new
      when 'pages'
        Wax::PageBuilder.new
      else
        raise Wax::Error, "Builder was initialized with invalid strategy \"#{@strategy}\". Must be one of #{BuildStrategies.valid}"
      end
    end

    def build
      raise Wax::Error, 'Called method #build on abstract class Builder. Perhaps you meant to create a PageBuilder, IIIFBuilder, or SimpleImageBuilder?'
    end
  end
end
