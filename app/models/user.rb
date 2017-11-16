class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def as_json(options)
    super(:only => [:id, :email, :created_at])
  end
end
