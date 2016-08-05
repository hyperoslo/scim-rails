# frozen_string_literal: true
Rails.application.routes.draw do
  resources :users
  mount SCIM::Engine => '/scim'
end
