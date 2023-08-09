# frozen_string_literal: true

module Wax
  module DictionaryLoader
    def self.load(file)
      path = Utils.absolute_path(file)
      File.file?(path) ? Utils.read_yaml(path) : {}
    end
  end
end
