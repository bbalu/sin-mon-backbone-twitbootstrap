#require "rubygems"
require 'sinatra'
require 'json'
require 'mongoid'

#set :public_folder, '/'

# MongoDB configuration
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('test')
    #config.master = Mongo::Connection.new.db("test")
  end
end

#models
class Feedback
	include Mongoid::Document
	#store_in collection: "feedbacks", db: "test"

	field :rating, :type => Integer
	field :newsletter, :type => Boolean
	field :create_at, :type => DateTime
	field :comments
	field :location, :type => Hash
	field :email 

end

get '/' do
	print 'root called'
	send_file "public/index.html", :type => 'text/html', :disposition => 'inline'
	#print "public folder: #{:public_folder}"
	#erb :summary
end

get '/api/v1' do
	content_type :json
  	{ :result => 'invalid command'}.to_json
end

get '/api/v1/feedbacks/summary' do
	content_type :json
	{:result => 'not implemented yet'}.to_json
end

get '/api/v1/feedbacks/search' do
	content_type :json	

	print "parameters:#{params}"
	#Feedback.where(rating: 0).to_a.to_json
	#Feedback.where(:email.neq null).to_a.to_json

	#{:result => 'not implemented yet'}.to_json
	#params[:rating]
#where(rating: 0)

end

get '/api/v1/feedbacks' do
	content_type :json
	Feedback.all.to_a.to_json
	#{:result => 'not implemented yet'}.to_json
end

post '/api/v1/feedbacks' do
	content_type :json
	
	record = JSON.parse request.body.read
	puts "record: #{record}"

	feedback = Feedback.new(record)
	feedback.save!
	puts "feedback record: #{feedback}"
	{:result => 'posted successfully'}.to_json
end

put '/api/v1/feedback/:id' do
	content_type :json
	{:result => 'not implemented yet'}.to_json
end

# delete a feedback
delete '/api/v1/feedbacks/:id' do
	content_type :json
	puts "params: #{params}"
	feedback = Feedback.find(params[:id])

	if !feedback.nil?
		puts "feedback"
		puts feedback.comments
		puts feedback._id
		puts feedback.rating
		feedback.delete
	end
		
	{:result => 'deleted successfully'}.to_json
end

