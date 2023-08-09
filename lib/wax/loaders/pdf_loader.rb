# frozen_string_literal: true

begin
  require 'vips'
rescue LoadError
  raise Wax::DependencyError, "Wax now uses Libvips to create derivatives instead of ImageMagick!\nPlease install Libvips using the instructions at https://libvips.github.io/libvips/install.html.\n\n"
end

require 'pdf-reader'
require 'progress_bar'

module Wax
  module PdfLoader
    def self.load(dir)
      pdfs = Dir.glob("#{dir}/*.pdf")
      pdfs.each { |file| split_pdf_images file }
    end

    def self.split_pdf_images(file)
      target_dir = file.gsub '.pdf', ''
      return unless Dir.glob("#{target_dir}/*").empty?

      puts Rainbow("\nPreprocessing #{File.basename(file)} into image files. This may take a minute.\n").cyan
      FileUtils.mkdir_p target_dir

      page_count = PDF::Reader.new(file).page_count
      bar        = ProgressBar.new page_count

      bar.write
      (0..page_count - 1).each do |index|
        target  = "#{Utils.padded_int(index, page_count)}.jpg"
        img     = Vips::Image.new_from_file file, page: index

        img.jpegsave File.join target_dir, target
        bar.increment! and bar.write
      end
    end
  end
end
