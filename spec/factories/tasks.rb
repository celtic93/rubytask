FactoryBot.define do
  factory :task do
    body { "Body Text" }
    association :user, factory: [:user, :client]

    trait :invalid do
      body { nil }
    end
  end
end
