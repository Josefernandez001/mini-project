class BookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2
	def perform(title, first_name, last_name , age)
		BookModel::BookCreator.call(
      title, first_name,
      last_name, age
    )
  end
end