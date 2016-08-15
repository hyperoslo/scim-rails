# frozen_string_literal: true
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
