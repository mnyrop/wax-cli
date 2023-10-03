# frozen_string_literal: true

class Hash
  def deep_compact
    delete_if do |k, v|
      (v.respond_to?(:empty?) ? v.empty? : !v) or v.instance_of?(Hash) && v.deep_compact.empty?
    end
  end
end