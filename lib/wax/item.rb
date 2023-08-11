# frozen_string_literal: true

require 'forwardable'

module Wax
  class Item
    attr_reader :pid, :label, :order, :metadata, :assets, :derivatives, :thumbnail, :full_image

    def initialize(pid, opts)
      @pid          = pid
      @label        = opts.fetch 'label',        pid
      @order        = opts.fetch 'order',        ''
      @metadata     = opts.fetch 'metadata',     {}
      @assets       = opts.fetch 'assets',       {}
      @derivatives  = opts.fetch 'derivatives',  {}
      @thumbnail    = opts.fetch 'thumbnail',    ''
      @full_image   = opts.fetch 'full_image', ''
    end

    def to_h
      {
        'pid' => pid,
        'label' => label,
        'order' => order,
        'thumbnail' => thumbnail,
        'full_image' => full_image,
        'is_paged' => paged?,
        'metadata' => metadata,
        'assets' => assets,
        'derivatives' => derivatives
      }
    end

    def paged?
      derivatives.to_h.fetch('simple', {}).keys.size > 1
    end

    def to_yaml
      compact_hash.to_yaml
    end

    def compact_hash
      Utils.compact_hash to_h
    end

    def simple_derivatives=(derivatives)
      @derivatives.to_h['simple'] = derivatives
      @thumbnail = derivatives.first[1]['thumbnail']
      @full_image = derivatives.first[1]['full_image']
    end

    def clear_simple_derivatives
      @derivatives.to_h.delete 'simple'
      @thumbnail  = nil
      @full_image = nil
    end

    def clear_assets
      @assets = {}
    end
  end
end
