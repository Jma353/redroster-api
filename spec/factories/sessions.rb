FactoryGirl.define do
  factory :session do
    user_id 1
    google_token "MyString"
    is_active false
  end
end
