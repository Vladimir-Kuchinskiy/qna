# frozen_string_literal: true

module ReputationCalculatable
  extend ActiveSupport::Concern

  included do
    after_create :update_reputation
  end

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
