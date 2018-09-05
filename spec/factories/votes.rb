# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user nil
    question nil
    answer nil
    voted false
  end
end
