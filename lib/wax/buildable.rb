# frozen_string_literal: true

module Wax
  module Buildable
    def infer_build_strategies
      build = config.fetch 'build', {}
      Wax::Validate.build_strategies build.keys
    end

    def add_build_strategies(*args)
      valid = Wax::Validate.build_strategies args.flatten
      @build_strategies.concat valid
    end

    def clear_build_strategies
      @build_strategies.clear
    end

    def reset_build_strategies(*args)
      clear_build_strategies
      add_build_strategies args.flatten
    end

    def reorder_strategies!
      @build_strategies.sort_by! { |name| name == 'pages' ? 1 : 0 }
    end
  end
end
