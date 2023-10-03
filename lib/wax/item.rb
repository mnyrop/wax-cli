# frozen_string_literal: true

require 'forwardable'

module Wax
  class Item
    attr_accessor :iiif_manifest
    attr_reader :pid, :label, :order, :metadata, :assets, :derivatives, :thumbnail, :banner, :full_image

    def initialize(pid, opts)
      @pid            = pid
      @label          = opts.fetch 'label',         pid
      @order          = opts.fetch 'order',         ''
      @metadata       = opts.fetch 'metadata',      {}
      @assets         = opts.fetch 'assets',        {}
      @derivatives    = opts.fetch 'derivatives',   {}
      @thumbnail      = opts.fetch 'thumbnail',     ''
      @banner         = opts.fetch 'banner',        ''
      @full_image     = opts.fetch 'full_image',    ''
      @iiif_manifest  = ''
    end

    def to_h
      {
        'pid' => pid,
        'label' => label,
        'order' => order,
        'thumbnail' => thumbnail,
        'banner' => banner,
        'full_image' => full_image,
        'is_paged' => paged?,
        'metadata' => metadata,
        'assets' => assets,
        'derivatives' => derivatives,
        'iiif_manifest' => iiif_manifest
      }
    end

    def paged?
      derivatives.to_h.fetch('simple', {}).keys.size > 1
    end

    def to_yaml
      compact_hash.to_yaml
    end

    def compact_hash
      to_h.deep_compact
    end

    def simple_derivatives=(derivatives)
      primary = derivatives.first[1] || {}

      @derivatives.to_h['simple'] = derivatives
      @thumbnail  = primary['thumbnail']
      @banner     = primary['banner']
      @full_image = primary['full_image']
    end

    def clear_simple_derivatives
      @derivatives.to_h.delete 'simple'
      @thumbnail  = nil
      @banner     = nil
      @full_image = nil
    end

    def clear_iiif_derivatives
      @derivatives.to_h.delete 'iiif'
    end

    def clear_assets
      @assets = {}
    end
  end
end
