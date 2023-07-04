FactoryBot.define do
  factory :stream do
    name { 'stream' }

    association :user
    association :group
    association :source
  end
end
