FactoryBot.define do
  factory :subscription do
    user { nil }
    question { nil }
    subscribed { false }
  end
end
