# frozen_string_literal: true

require_relative 'pdf_loader'

module Wax
  module AssetsLoader
    def self.load(dir)
      root_path = Utils.absolute_path dir
      warn Rainbow("Warning!! Tried to load assets for collection #{name} from #{root_path} but that directory does not exist.").orange and return [] unless File.directory? root_path

      Wax::PdfLoader.load root_path

      paths = Dir.glob("#{root_path}/*[!.pdf]")
      paths.map { |path| assets_hash path }
    end

    def self.pid(path)
      File.basename path, File.extname(path)
    end

    def self.type(path)
      File.directory?(path) ? 'dir' : File.extname(path).downcase.tr('.', '')
    end

    def self.assets_hash(path)
      paths = type(path) == 'dir' ? Dir.glob(File.join(path, '*')) : [path]
      {
        pid(path) => paths.map { |child| { 'type' => type(child), 'path' => child } }
      }
    end
  end
end
