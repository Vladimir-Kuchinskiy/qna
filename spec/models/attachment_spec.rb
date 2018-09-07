# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }

  describe '#destroy_if_owner' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }

    context 'Question' do
      let(:attachable) { create(:question, user: user) }
      let!(:attachment) { create(:attachment, attachable: attachable) }

      it_behaves_like 'Attachable'
    end

    context 'Answer' do
      let(:attachable) { create(:question, user: user) }
      let!(:attachment) { create(:attachment, attachable: attachable) }

      it_behaves_like 'Attachable'
    end
  end

  describe '.files?' do
    it 'returns true if there is any file in DB' do
      create(:attachment, attachable: create(:question, user: create(:user)))
      expect(Attachment.files?).to eq true
    end

    it 'returns false if there is no files in DB' do
      expect(Attachment.files?).to eq false
    end
  end
end
