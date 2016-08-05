# frozen_string_literal: true
require 'ostruct'

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

# bridge between SCIM::User and your Project User model
class UserConversor
  # TODO: handle error cases
  def self.scim_serialize(user)
    SCIM::User.new(
      id: user.id,
      name: SCIM::User::Name.new(user.first_name, user.last_name, user.name),
      created_at: user.created_at,
      updated_at: user.updated_at,
      external_id: user.employee_number,
      user_name: user.identifier_value,
      phone_numbers: [user.phone_number],
      emails: [user.email]
    )
  end

  def self.scim_deserialize(scim_user)
    User.new(
      employee_number: scim_user.external_id,
      phone_number: scim_user.phone_numbers.first,
      email: scim_user.emails.first,
      first_name: scim_user.name.given_name,
      last_name: scim_user.name.family_name
    )
  end
end

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
      params = fix_ruby_format(params)
      scim_user = SCIM::User.new(params)
      user = conversor.scim_deserialize(scim_user)
      user.save!
      conversor.scim_serialize(user)
    end

    def self.fix_ruby_format(params)
      external_id = params.delete('externalId')
      params['external_id'] = external_id

      phone_numbers = params.delete('phoneNumbers')
      params['phone_numbers'] = phone_numbers

      employee_number = params.delete('employeeNumber')
      params['employee_number'] = employee_number

      fix_name(params)
    end

    def self.fix_name(params)
      name = params['name']
      name['family_name'] = name.delete('familyName')
      name['given_name'] = name.delete('givenName')
      params['name'] = name

      params
    end
  end
end

module SCIM
  # user resource controller
  class UsersController < ApplicationController
    def index
      users = UserRepository.all
      render json: users
    end

    def create
      user = UserRepository.create(params['parameters'])
      render json: user, status: 201
    end
  end
end
