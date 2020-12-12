FactoryBot.define do
  factory :comment do
    body { "Comment Body Text" }
    task
    association :user, factory: [:user, :client]

    trait :invalid do
      body { nil }
    end
  end
end
