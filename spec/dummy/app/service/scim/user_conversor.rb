# frozen_string_literal: true
module SCIM
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
      ::User.new(
        employee_number: scim_user.external_id,
        phone_number: scim_user.phone_numbers.first,
        email: scim_user.emails.first,
        first_name: scim_user.name.given_name,
        last_name: scim_user.name.family_name
      )
    end
  end
end
