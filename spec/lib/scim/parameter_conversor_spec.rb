# frozen_string_literal: true
require 'scim/parameter_conversor'

describe SCIM::ParameterConversor do
  def camel_case_hash
    {
      phoneNumbers: [{ countryCode: '+47', number: '12341232' },
                     { countryCode: '+43', number: '44444444' }],
      name: {
        firstName: 'Anthony', lastName: 'Stark', displayName: 'Tony Stark'
      },
      externalId: '1234',
      knownAs: [{ superhero: [{ superheroName: 'Iron Man' }] }]
    }
  end

  def snake_case_hash
    {
      phone_numbers: [{ country_code: '+47', number: '12341232' },
                      { country_code: '+43', number: '44444444' }],
      name: {
        first_name: 'Anthony', last_name: 'Stark', display_name: 'Tony Stark'
      },
      external_id: '1234',
      known_as: [{ superhero: [{ superhero_name: 'Iron Man' }] }]
    }
  end

  describe '#to_snake_case_keys' do
    it 'converts a hash with camel case keys to one with snake case keys' do
      result = SCIM::ParameterConversor.to_snake_case_keys(camel_case_hash)
      expect(result).to eq(snake_case_hash)
    end
  end

  describe '#to_camel_case_keys' do
    it 'converts a hash with snake case keys to one with camel case keys' do
      result = SCIM::ParameterConversor.to_camel_case_keys(snake_case_hash)
      expect(result).to eq(camel_case_hash)
    end
  end
end
