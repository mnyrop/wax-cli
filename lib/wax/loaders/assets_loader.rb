# frozen_string_literal: true

module Wax
  module AssetsLoader
    def self.load(dir)
      path = Utils.absolute_path dir
      warn Rainbow("Warning!! Tried to load assets for collection #{name} from #{path} but that directory does not exist.").orange and return [] unless File.directory? path

      Dir.glob(File.join(path, '*')).map do |asset_path|
        ext   = File.extname(asset_path)
        pid   = File.basename(asset_path, ext)
        type  = File.directory?(asset_path) ? 'dir' : ext.tr('.', '')
        { 'pid' => pid, 'type' => type, 'path' => asset_path }
      end
    end
  end
end
