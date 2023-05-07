FactoryBot.define do
  factory :source do
    name { 'source' }
    url { 'https://source.com' }
    association :creator, factory: :user
  end
end
