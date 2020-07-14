FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@examplem.com' }
    password { 'password' }
  end
end
