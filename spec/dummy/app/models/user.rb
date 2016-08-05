class User < ActiveRecord::Base
  def name
    "#{first_name} #{last_name}"
  end

  def identifier_value
    email
  end
end
