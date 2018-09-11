class CalculateReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    object.user.update(reputation: Reputation.calculate(object))
  end
end
