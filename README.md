# SCIM

This project rocks and uses MIT-LICENSE.

## Installation

```
gem 'scim-rails'
```

## Usage

```ruby
mount SCIM::Engine => '/scim'
```

```ruby
# config/initializers/scim.rb

# scim_controller callbacks
```

```ruby
# app/models/user.rb
class User

end
```

```ruby
# app/modelts/user_spec.rb
describe User do
  it_behaves_like 'SCIM::User'
end
```

```
User
  first_name
  last_name
  phone_number
  email
  employee_number
  id
  organization_id
  role
```

```
SCIM::User
  id
  created_at
  updated_at
  meta
    created
    last_modified
  external_id
  user_name
  emails
  phone_numbers
  name
    family_name
    given_name
    formatted
```

```
in_ruby_format(params)

# UserConversor.scim_deserialize(SCIM::User) -> User
params = {
  external_id: 3,
  user_name: 'foobar',
  phone_numbers: ['+230234412'],
  emails: ['felipe@hyper.no'],
  name: {
    given_name: 'Felipe',
    family_name: 'Espinoza',
    formatted: 'Felipe Espinoza'
  }
}

# read
SCIM::User.new(user)
  Meta = Struct.new(:created, :last_modified)
  Name = Struct.new(:given_name, :family_name, :formatted)

  def meta
    @meta ||= Meta.new(created: created_at, last_modified: updated_at)
  end

  def to_hash
  end

  def original_user
    @original_user ||= User.find(id)
  end
end
```

```ruby
# conversor
class UserConversor
  # UserConversor.scim_serialize(User) -> SCIM::User
  def self.scim_serialize(user)
    SCIM::User.new(
      id: user.id,
      name: Name.new(user.first_name, user.last_name, user.name),
      created_at: user.created_at,
      updated_at: user.updated_at,
      external_id: user.employee_number,
      user_name: user.identifier_value,
      phone_numbers: [user.phone_numbers],
      emails: [user.email]
    )
    # handle error cases
  end

  def self.scim_deserialize(scim_user)
    User.new(
      employee_number: scim_user.external_id,
      phone_number: scim_user.phone_numbers.first,
      email: scim_user.emails.first,
      first_name: scim_user.name.given_name,
      last_name: scim_user.name.family_name,
    )
  end
end
```

```ruby
# configuration
SCIM.configure do |config|
  config.user_model = User
  config.user_conversor = SCIMUserConversor
end
```

```ruby
# repository
class SCIM::UserRepository
  def self.config
    SCIM::Configuration.shared_instance
  end

  def self.conversor
    config.conversor
  end

  def self.fetch_all
    SerializedPromise.new(config.user_model.all)
  end

  def self.fetch(params)
    conversor.scim_deserialize(user_model.find(params))
  end

  def self.create(params)
    params = fix_ruby_format(params)
    scim_user = SCIM::User.new(params)
    return false unless scim_user.valid?

    begin
      user = conversor.scim_deserialize(scim_user)
      user.save!
      conversor.scim_serialize(user)
    rescue
      handle_creation_errors
    end
    conversor.scim_deserialize(user_model.find(params))
  end
end
```
