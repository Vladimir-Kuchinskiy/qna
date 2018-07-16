# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body 'MyText'
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end

  factory :another_answer, class: 'Answer' do
    body "AnotherText"
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end
end
