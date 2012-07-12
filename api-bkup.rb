#require "rubygems"
require 'sinatra'
require './feedbacks'
require 'json'

before do 
	Feedbacks.connect( {:server => 'localhost', :db => 'test'})
end

get '/' do
	content_type :html	
end

get '/api/v1' do
	content_type :json
  	{ :result => 'invalid command'}.to_json
end

get '/api/v1/feedbacks/summary' do
	content_type :json

end

get '/api/v1/feedbacks/search' do
	content_type :json	

	puts "Search string: #{params}"

	if (params.nil?)
		@feedbacks = Feedbacks.find :all
	else
		@feedbacks = Feedbacks.find params
	end
	@feedbacks.to_json

end

get '/api/v1/feedbacks' do

	content_type :json

	@feedbacks = Feedbacks.find :all
	@feedbacks.to_json
	
end

# new form
# post a new feedback
post '/api/v1/feedback/' do
	#print '/Post called'

	#params.reject! {|k,v| k == "submit"}
	Feedbacks.save(params)
	#redirect "/feedbacks"
end

put '/api/v1/feedback/:id' do
	#print '/new form requested'
	#erb :new
end

# delete a feedback
delete '/api/v1/delete/:id' do
	Feedbacks.delete(params[:id])
	#redirect "/feedbacks"
end



get '/summary' do
	print 'summary called........................'
	erb :summary
end

get '/lists' do
	print 'lists called..........................'
	erb :lists
end

get '/new' do
	print 'new called............................'
	erb :new
end