FactoryBot.define do
  factory :article do
    title { 'article' }
    link { 'https://source.com' }

    association :source
  end
end
