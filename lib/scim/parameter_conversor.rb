# frozen_string_literal: true
require 'facets'

module SCIM
  # to contain logic for transformation between camel case and snake case
  class ParameterConversor
    def self.to_snake_case_keys(object)
      snake_case_key = proc { |key| key.to_s.snakecase.to_sym }
      transform_keys(object, snake_case_key)
    end

    def self.to_camel_case_keys(object)
      camel_case_key = proc { |key| key.to_s.camelcase.to_sym }
      transform_keys(object, camel_case_key)
    end

    def self.transform_keys(object, transformation)
      case object
      when Hash
        transform_keys_for_hash(object, transformation)
      when Array
        transform_keys_for_array(object, transformation)
      else
        object
      end
    end

    def self.transform_keys_for_hash(hash, transformation)
      new_hash = {}
      hash.each_pair do |key, value|
        new_key = transformation.call(key)
        new_hash[new_key] = transform_keys(value, transformation)
      end
      new_hash
    end

    def self.transform_keys_for_array(array, transformation)
      array.map { |value| transform_keys(value, transformation) }
    end
  end
end
