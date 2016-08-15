# frozen_string_literal: true
module SCIM
  # top level controller for the scim module
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
