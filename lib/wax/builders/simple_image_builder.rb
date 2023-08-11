# frozen_string_literal: true

require 'dry-configurable'
require 'parallel'
require 'ruby-progressbar'
require 'vips'

require_relative '../builder'

module Wax
  class SimpleImageBuilder < Builder
    include Dry::Configurable

    setting :variants,         reader: true
    setting :derivatives_dir,  reader: true

    VALID_FORMATS = %w[png jpg jpeg tiff tif jp2 gif].freeze

    def load_configuration
      config.variants         = custom_variants
      config.derivatives_dir  = Utils::Path.safe_join collection_config.derivatives_dir, 'simple'
    end

    def validate
      raise Wax::Error, "Config provided to SimpleImageBuilder does not have required field 'derivatives_dir'" if collection_config&.derivatives_dir.to_s.empty?
    end

    def build(items)
      @items = items

      raise Wax::Error, 'Called .build(items) but was not provided an array of Wax::Item objects', "Culprit: #{items.inspect}" unless Utils.all_items? items

      GC.start
      puts Rainbow("\nWriting image derivatives. This may take a minute.").cyan
      @items = Parallel.map(items, progress: { format: '%e %B %c/%u %P% Complete' }) do |item|
        write_derivatives item
      end
      update_json
      puts Rainbow("Done ✓\n").green
      @items
    end

    def clobber(items, force: false)
      puts Rainbow("Clobbering simple image derivatives in #{Utils::Path.working config.derivatives_dir}").cyan
      @items = items.map do |item|
        item.clear_assets
        item.clear_simple_derivatives
        item
      end
      update_json unless force
      FileUtils.rm_rf config.derivatives_dir
      puts Rainbow("Done ✓\n").green
    end

    def default_variants
      {
        'full_image' => 1140,
        'thumbnail' => 400
      }
    end

    def custom_variants
      variant_config = opts.fetch 'variants', {}
      non_number     = variant_config.find { |_k, value| !value.is_a?(Integer) }

      raise Wax::ConfigError, 'Custom variant config must be in hash format', "Culprit: #{variant_config} (type=#{variant_config.class})" unless variant_config.is_a? Hash
      raise Wax::ConfigError, "Custom variant '#{non_number[0]}' has invalid value '#{non_number[1]}'. It must be an integer." if non_number

      default_variants.merge variant_config
    end

    def write_derivatives(item)
      assets      = item.assets.select { |_k, path| VALID_FORMATS.include? Utils::Image.file_type(path) }
      target_dir  = File.join config.derivatives_dir, item.pid

      return item unless assets.any?

      item.simple_derivatives = assets.map.to_h { |asset| write_derivative_variants(target_dir, asset) }
      item
    end

    def write_derivative_variants(target_dir, asset)
      num     = asset[0]
      source  = asset[1]
      dir     = File.join target_dir, num.to_s
      image   = Vips::Image.new_from_file source

      FileUtils.mkdir_p dir
      results = config.variants.map.to_h do |key, width|
        target = File.join dir, "#{key}.jpg"
        Utils::Image.new_variant(image, width).jpegsave target unless File.file? target
        [key, prune_source(target)]
      end
      [num, results]
    end
  end
end
