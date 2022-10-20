require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
RSpec.describe BookWorker, type: :worker do
  describe "" do
    it "job in correct queue" do
      described_class.perform_async
      assert_equal :queuenamehere, described_class.queue
    end
  end
end
