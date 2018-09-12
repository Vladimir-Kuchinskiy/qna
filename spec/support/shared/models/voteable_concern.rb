# frozen_string_literal: true

shared_examples_for 'Voteable' do
  # described_class is the class that includes the concern

  describe '#give_vote' do
    let!(:user) { create(:user) }

    context 'user can vote' do
      it "gives the vote for #{described_class.name.downcase}" do
        expect { subject.give_vote(user, 1) }.to change(subject, :votes_count).by(1)
      end

      it 'returns the value of true' do
        expect(subject.give_vote(user, 1)).to eq true
      end
    end

    context 'user can not vote' do
      let!(:vote) { create(:vote, user: user, voteable: subject, choice: 1) }
      it 'returns an access denied error' do
        subject.give_vote(user, 1)
        expect(subject.errors[:votes_count]).to_not be_blank
      end

      it "returns #{described_class.name.downcase}" do
        expect(subject.give_vote(user, 1)).to be_a(described_class)
      end
    end
  end

  describe '#remove_vote' do
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, user: user, voteable: subject, choice: 1) }

    context 'user can vote' do
      before { subject.update(votes_count: 1) }
      it "dismiss the vote for #{described_class.name.downcase}" do
        expect { subject.remove_vote(user) }.to change(subject, :votes_count).by(-1)
      end

      it 'returns the value of true' do
        expect(subject.remove_vote(user)).to eq true
      end
    end

    context 'user can not vote' do
      before { vote.destroy }
      it 'returns an access denied error' do
        subject.remove_vote(user)
        expect(subject.errors[:votes_count]).to_not be_blank
      end

      it "returns #{described_class.name.downcase}" do
        expect(subject.remove_vote(user)).to be_a(described_class)
      end
    end
  end
end