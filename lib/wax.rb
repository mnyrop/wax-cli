# frozen_string_literal: true

require 'fileutils'
require 'rainbow'

require_relative 'wax/error'

require_relative 'wax/builder'
require_relative 'wax/cli'
require_relative 'wax/collection'
require_relative 'wax/factory'
require_relative 'wax/item'
require_relative 'wax/lint'
require_relative 'wax/project'
require_relative 'wax/utils'
require_relative 'wax/version'

require_relative 'wax/parsers/dictionary'
require_relative 'wax/parsers/records'
require_relative 'wax/parsers/asset_map'
require_relative 'wax/parsers/items'

module Wax; end
