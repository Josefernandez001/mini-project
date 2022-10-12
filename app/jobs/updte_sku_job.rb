class UpdteSkuJob < ApplicationJob
  queue_as :default

  def perform(book_params)
    uri = URI('http://localhost:4567/update_sku')
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'aplication/json')
    req.body = {sku: '123', name: book_params[:title]}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |htpp|
      http.request(req)
    end

  end
end
