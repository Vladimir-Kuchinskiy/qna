# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title 'MyString'
    body 'MyText'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
