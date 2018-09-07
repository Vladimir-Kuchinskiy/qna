# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:attachments) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:the_best).scoped_to(:question_id) }

  it { should accept_nested_attributes_for :attachments }

  subject { create(:answer, user: create(:user), question: create(:question)) }
  it_behaves_like 'Voteable'
end
