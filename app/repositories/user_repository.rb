class UserRepository
  def self.find(id)
    User.find_by_id(id)
  end

  def self.find_by_email(email)
    User.find_by_email(email)
  end

  def self.create(email, password, password_confirmation)
    User.create!(email: email, password: password, password_confirmation: password_confirmation)
  end
end
