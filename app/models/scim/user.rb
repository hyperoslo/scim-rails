# frozen_string_literal: true
module SCIM
  # SCIM representation of an user
  class User
    Meta = Struct.new(:created, :last_modified)
    Name = Struct.new(:given_name, :family_name, :formatted)

    def initialize(params = {})
      @params = OpenStruct.new(params)
    end

    def meta
      @meta ||= Meta.new(created: created_at, last_modified: updated_at)
    end

    def name
      @name ||= begin
                  name = @params['name']
                  Name.new(
                    name['given_name'], name['family_name'], name['formatted']
                  )
                end
    end

    def original_user
      @original_user ||= User.find(id)
    end

    def method_missing(meth, *args, &blk)
      @params.send(meth, *args, &blk)
    end
  end
end
