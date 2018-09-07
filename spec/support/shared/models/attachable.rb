# frozen_string_literal: true

shared_examples_for 'Attachable' do
  context 'user is owner' do
    it 'destroys the attachment' do
      expect { attachment.destroy_if_owner(user) }.to change(attachable.attachments, :count).by(-1)
    end

    it 'returns the destroyed object of the attachment' do
      expect(attachment.destroy_if_owner(user)).to be_a(Attachment)
    end
  end

  context 'user is not owner' do
    it 'does not destroy attachment' do
      expect { attachment.destroy_if_owner(other_user) }.to_not change(attachable.attachments, :count)
    end

    it 'adds access denied error' do
      attachment.destroy_if_owner(other_user)
      expect(attachment.errors).to have_key(:file)
    end

    it 'returns attachment object' do
      expect(attachment.destroy_if_owner(other_user)).to be_a(Attachment)
    end
  end
end