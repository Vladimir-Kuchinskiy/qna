# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should have_many :attachments }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_uniqueness_of(:the_best).scoped_to(:question_id) }
end
