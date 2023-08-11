# frozen_string_literal: true

module Wax
  module Parsers
    module Dictionary
      def self.parse(file)
        path = Utils::Path.absolute(file)
        File.file?(path) ? Utils::Read.yaml(path) : {}
      end
    end
  end
end
