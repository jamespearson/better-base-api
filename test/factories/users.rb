FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    trait :admin do
      roles_mask { User.mask_for :admin }
    end
  end
end
