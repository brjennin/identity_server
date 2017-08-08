class UserRepository
  def self.find(id)
    User.find_by_id(id)
  end

  def self.find_by_email(email)
    User.find_by_email(email)
  end
end
