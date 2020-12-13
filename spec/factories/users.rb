FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    login { 'login' }
    fullname { 'fullname' }
    address { 'address' }
    city { 'city' }
    state { 'state' }
    country { 'country' }
    zip { 'zip' }
    birthday { Date.today }
    role { 'client' }

    trait :admin do
      role { 0 }
    end

    trait :worker do
      role { 1 }
    end

    trait :client do
      role { 2 }
    end

    trait :invalid do
      login { nil }
    end
  end
end
