#require "rubygems"

require 'bundler/setup'
require 'em-websocket'
require 'sinatra'
require 'json'
require 'mongoid'

# for mongoid 3.0.0, use Ruby 1.9.3 

# MongoDB configuration
class Feedback
	include Mongoid::Document
	#store_in collection: "feedbacks", database: "test"

	field :rating, :type => Integer
	field :newsletter, :type => Boolean
	field :create_at, :type => DateTime
	field :comments
	field :location, :type => Hash
	field :email 

end

EM.run do
	class MyApp < Sinatra::Base

		#Mongoid.load!("mongoid.yml")
		Mongoid.configure do |config|
		  #config.allow_dynamic_fields = false
		  config.load!("mongoid.yml")
		  print "sessions: #{config.sessions}"

		  #config.use(name: "test", host: "localhost", port: 27017)
		  #config.connect_to("test")

		end
		#connection = Mongo::Connection.new("localhost", 27017)
		#db = connection.db("local")
		#col1 = db["feedbacks"]
		#print col1

		#models

		Mongoid.logger.level = Logger::DEBUG
		Moped.logger.level = Logger::DEBUG


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
			print "get #{params}"
			content_type :json
			#TBD. if no records were returned or error access the collection in the database

			feedbacks = Feedback.all
			print "feedbacks:------------"
			print feedbacks.inspect
			print feedbacks
			print "------------------------------------"
			#TBD: null check not working?????????????????????
			if !feedbacks.nil? || !feedbacks.empty?
				feedbacks.to_a.to_json
			else
				error 404, "no records found".to_json	
			end
				
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
	end

	EM::WebSocket.start(:host => '0.0.0.0', :port => 3001) do
    	# Websocket code here
  	end

  	# You could also use Rainbows! instead of Thin.
  	# Any EM based Rack handler should do.
  	Thin::Server.start MyApp, '0.0.0.0', 3000
end  
