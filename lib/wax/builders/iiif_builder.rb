# frozen_string_literal: true

require 'wax_iiif'

require_relative '../builder'

module Wax
  class IIIFBuilder < Builder
    include Dry::Configurable

    setting :derivatives_dir, reader: true
    setting :iiif_url,        reader: true

    def load_configuration
      config.derivatives_dir = Utils::Path.safe_join collection_config.derivatives_dir, 'iiif'
      config.iiif_url        = File.join "{{ '' | absolute_url }}", prune_source(config.derivatives_dir)
    end

    def validate
      raise Wax::Error, "Config provided to IIIFBuilder does not have required field 'derivatives_dir'" if collection_config&.derivatives_dir.to_s.empty?
    end

    def build(items)
      @items = items

      raise Wax::Error, 'Called .build(items) but was not provided an array of Wax::Item objects', "Culprit: #{items.inspect}" unless Utils.all_items? items

      puts Rainbow('Building IIIF resources...').cyan
      print Utils::Print.checkmark, "Writing to #{config.derivatives_dir}\n"
      build_opts = {
        base_url: config.iiif_url,
        output_dir: "#{Utils::Path.absolute config.derivatives_dir}",
        collection_label: collection_config.name
      }
      builder = WaxIiif::Builder.new build_opts
      builder.load iiif_image_records
      builder.process_data 
      results = builder.results
      Dir.glob("#{Utils::Path.absolute config.derivatives_dir}/**/*.json").each do |f|
        Utils.add_yaml_front_matter_to_file f
      end
      @items.map do |item|
        item.iiif_manifest = prune_source(results[item.pid]) if results.key? item.pid
        item
      end

      update_wax_json
      print Utils::Print.checkmark, Rainbow("Done!\n").green
      @items
    end


    def iiif_image_records
      data = []
      @items.each do |item|
        item.assets.each do |key,path| 
          opts = {
            is_primary:    key.to_i.zero?,
            path:          path,
            manifest_id:   item.pid,
            id:            "#{item.pid}_#{key}"
          }
          data << WaxIiif::ImageRecord.new(opts)
        end
      end
      data
    end

    def clobber(items, force:false)
      puts Rainbow('Clobbering IIIF derivatives...').cyan
      @items = items.map do |item|
        item.clear_assets
        item.clear_iiif_derivatives
        item
      end
      update_wax_json unless force
      print Utils::Print.checkmark, "Clearing out #{Utils::Path.working config.derivatives_dir}\n"
      FileUtils.rm_rf config.derivatives_dir
      print Utils::Print.checkmark, Rainbow("Done!\n").green
    end
  end
end
