# frozen_string_literal: true

module Wax
  module BuildStrategies
    def self.valid
      %w[simple_images iiif pages].freeze
    end

    def self.validate(list)
      list.find_all { |key| BuildStrategies.valid.include? key }
    end

    def self.reorder(list)
      list.sort_by! { |name| name == 'pages' ? 1 : 0 }
    end

    def infer_build_strategies
      build = @opts['build']
      return [] unless build.is_a? Hash

      BuildStrategies.reorder(BuildStrategies.validate(build.keys))
    end

    def add_build_strategies(*args)
      valid = BuildStrategies.validate args.flatten
      @build_strategies.concat valid
      reorder_strategies!
    end

    def strategy_opts(strategy)
      return {} unless BuildStrategies.valid.include? strategy

      @opts.dig('build', strategy)
    end

    def clear_build_strategies
      @build_strategies.clear
    end

    def overwrite_build_strategies(*args)
      clear_build_strategies
      add_build_strategies args.flatten
    end

    def reorder_strategies!
      @build_strategies.sort_by! { |name| name == 'pages' ? 1 : 0 }
    end
  end
end
