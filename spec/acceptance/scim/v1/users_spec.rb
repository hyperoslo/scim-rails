# frozen_string_literal: true
require 'rails_helper'

resource 'Users' do
  get '/scim/Users' do
    example 'returns list of all users for current organization' do
      user = User.create(
        first_name: 'felipe',
        last_name: 'espinoza',
        email: 'foo@bar.com',
        phone_number: '12345678',
        employee_number: '123'
      )
      do_request

      expect(status).to eq(200)
      json_response = JSON.load(response_body)
      expect(json_response).to eq(
        meta: {
          created: user.created_at.to_s,
          lastModified: user.updated_at.to_s
        },
        id: user.id,
        externalId: user.id,
        userName: user.email,
        emails: [user.email],
        phoneNumbers: [user.phone_number],
        name: {
          formatted: user.name,
          familyName: user.last_name,
          givenName: user.first_name
        },
        schemas: [
          'urn:scim:schemas:core:1.0',
          'urn:scim:schemas:extension:enterprise:1.0'
        ]
      )
    end
  end

  post '/scim/Users' do
    example 'creates a new user' do
      parameters = {
        schemas: [
          'urn:scim:schemas:core:1.0',
          'urn:scim:schemas:extension:enterprise:1.0'
        ],
        emails: ['test@example.com'],
        phoneNumbers: ['+375292613722'],
        employeeNumber: '12345',
        externalId: '12345',
        name: {
          familyName: 'Ermolovich',
          givenName: 'Vasiliy'
        }
      }

      do_request parameters: parameters

      expect(status).to eq(201)

      json_response = JSON.load(response_body).deep_symbolize_keys
      user = User.find_by!(employee_number: '12345')
      expect(json_response).to eq(
        meta: {
          created: user.created_at.to_s,
          lastModified: user.updated_at.to_s
        },
        id: user.id,
        externalId: user.id,
        userName: user.email,
        emails: [user.email],
        phoneNumbers: [user.phone_number],
        name: {
          formatted: user.name,
          familyName: user.last_name,
          givenName: user.first_name
        },
        schemas: [
          'urn:scim:schemas:core:1.0',
          'urn:scim:schemas:extension:enterprise:1.0'
        ]
      )
    end
  end
end
