# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    file { File.new("#{Rails.root}/spec/rails_helper.rb") }
  end
end
