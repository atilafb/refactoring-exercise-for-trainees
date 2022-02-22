FactoryBot.define do
  factory :user do
    email { 'user@spec.io' }
    first_name { 'John' }
    last_name  { 'Doe' }
    guest { false }
  end
end
