class User < ApplicationRecord
  has_secure_password

  def self.authenticate(ln, pass)
    User.authenticate_by(login: ln, password: pass)
  end
end
