# frozen_string_literal: true

require_relative 'base'

module Wax
  module Commands
    class Clobber < Base
      class_option :config,         type: :string,  default: './_config.yml', desc: 'Path to yaml config file'
      class_option :iiif,           type: :boolean, desc: 'If true, clobbers IIIF resources.'
      class_option :pages,          type: :boolean, desc: 'If true, clobbers markdown page(s).'
      class_option :simple_images,  type: :boolean, desc: 'If true, clobbers simple image derivatives.'
      class_option :force,          type: :boolean, default: false, desc: 'If true, resets wax.json file for the collection'

      desc 'collection NAME', 'Clobber the wax collection named NAME'
      def collection(name)
        build_opts = Wax::BuildStrategies.validate options.keys
        project    = Wax::Project.new options['config']
        collection = project.find_collection name

        raise Wax::CollectionError, "No collection found with name '#{name}'. Check your config?" unless collection.is_a? Wax::Collection

        collection.overwrite_build_strategies(build_opts) if build_opts.any?
        collection.clobber force: options['force']
      end

      desc 'collections', 'Clobber all available wax collections'
      def collections
        project = Wax::Project.new options['config']
        project.collections.each do |collection|
          collection.clobber force: options['force']
        end
      end

      desc 'item COLLECTION_NAME ITEM_ID', 'Clobber the item with ITEM_ID within COLLECTION_NAME collection'
      def item(name, id)
        puts "resetting item #{id} from collection #{name}"
      end
    end
  end
end
