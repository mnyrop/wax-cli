# frozen_string_literal: true

module Wax
  class SimpleImageBuilder
    attr_reader :items, :config

    def build(items, config)
      @items  = items
      @config = config

      validate

      items.each { |item| build_item item }
    end

    def validate
      raise Wax::Error, "Config provided to SimpleImageBuilder does not have required field 'derivatives_dir'" if config&.derivatives_dir.to_s.empty?
    end

    def target_dir
      @target_dir ||= Utils.absolute_path File.join(config.derivatives_dir, 'simple')
    end

    def build_item(item, _opts = config)
      puts "Building item #{item['pid']}"
    end
  end
end
