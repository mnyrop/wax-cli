# frozen_string_literal: true

class Hash
  def deep_compact
    delete_if do |_k, value|
      (value.respond_to?(:empty?) ? value.empty? : !value) or (value.instance_of?(Hash) && value.deep_compact.empty?)
    end
  end
end
