# frozen_string_literal: true
module SCIM
  # class where logic on how to perform database operations
  # for the user model is handled
  class UserRepository
    def self.user_model
      ::User
    end

    def self.conversor
      ::UserConversor
    end

    def self.all
      user_model.all.map { |user| conversor.scim_serialize(user) }
    end

    def self.create(params)
      params    = fix_ruby_format(params)
      scim_user = SCIM::User.new(params)
      user      = conversor.scim_deserialize(scim_user)
      user.save!
      conversor.scim_serialize(user)
    end

    def self.fix_ruby_format(params)
      ParameterConversor.to_snake_case_keys(params)
    end
  end
end
