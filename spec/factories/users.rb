FactoryGirl.define do
  factory :admin, class: User do
    email "admin@example.com"
    password "password"
    admin true
  end
end