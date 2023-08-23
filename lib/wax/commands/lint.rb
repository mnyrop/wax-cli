# frozen_string_literal: true

require_relative 'base'

module Wax
  module Commands
    class Lint < Base
      class_option :config, type: :string,  default: './_config.yml', desc: 'Path to yaml config file'

      desc 'collection NAME', 'Lint the wax collection named NAME'
      def collection(name)
        Wax::Lint.config options['config']
        project    = Wax::Project.new options['config']
        collection = project.find_collection name

        raise Wax::CollectionError, "No collection found with name '#{name}'. Check your config?" unless collection.is_a? Wax::Collection

        Wax::Lint.collection collection
      end

      desc 'collections', 'Lint all available wax collections'
      def collections
        Wax::Lint.config options['config']
        project = Wax::Project.new options['config']
        project.collections.each do |collection|
          Wax::Lint.collection collection
        end
      end
    end
  end
end
