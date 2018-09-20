# frozen_string_literal: true

# every 1.day do
#   runner 'DailyDigestJob.perform_later'
# end

every 60.minutes do
  rake 'ts:index'
end
