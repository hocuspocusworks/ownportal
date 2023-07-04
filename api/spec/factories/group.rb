FactoryBot.define do
  factory :group do
    name { 'group' }

    association :user
  end
end
