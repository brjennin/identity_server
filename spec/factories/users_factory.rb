FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password_digest "password"
  end
end
