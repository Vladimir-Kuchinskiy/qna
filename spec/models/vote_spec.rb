require 'rails_helper'

RSpec.describe Vote, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :user }
  it { should belong_to :question }
  it { should belong_to :answer }

  it { should validate_presence_of :voted }
end
