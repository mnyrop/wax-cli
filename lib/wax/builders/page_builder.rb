# frozen_string_literal: true

module Wax
  class PageBuilder
    attr_reader :items, :config

    def build(_items, _config)
      puts 'Building pages!'
    end
  end
end
