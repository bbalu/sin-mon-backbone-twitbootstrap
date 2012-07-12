# mongo-access.rb 
#require 'rubygems'  not needed for ruby 1.9.2 
require 'mongo'
require 'bson'

module Feedbacks
	class << self

		def summary()
			map = "function() { emit(this.author, {ratings: this.rating}); }"
			reduce = "function(key, values) { " +
						"var sum = 0; " +
						"values.forEach(function(doc) { " +
							" sum += doc.ratings; " +
						"}); " +
						"return {ratings: sum}; " +
					 "};" 
			@results = @db.collection("feedbacks").map_reduce(map, reduce, :out => "rating_results")
			@results.find().to_a
		end

  		def connect(config)
			@db = Mongo::Connection.new(config[:server], config[:port] || 27017).db(config[:db])
		end

		def find(search)
			if ( search == :all )
				feedbacks = @db.collection("feedbacks").find.to_a
				return nil_or_array(feedbacks)
			else 
				return find_with_criteria(search)
			end
		end
	
		def save(feedback)
			stringfy_keys(feedback)
			@db.collection("feedbacks").save(feedback)
		end

		def delete(id)
			feedback = @db.collection("feedbacks").find_one(::BSON::ObjectId.from_string(id))
			@db.collection("feedbacks").remove(feedback) if feedback
		end

		private

		def find_with_criteria(search)
			search = stringfy_keys(search)
			#feedbacks = @db.collection("feedbacks").find({"rating"=> 0}).to_a
			feedbacks = @db.collection("feedbacks").find(search).to_a	
			puts "feedbacks:#{feedbacks}"
			return nil_or_array(feedbacks)		
		end

		def nil_or_array(result)
			if result.size == 0
				return nil
			else 
				return result
			end
		end

		def stringfy_keys(hash)
			newhash = {}
			hash.each  do |key, value|
				if key == "rating"
					newhash[key] = value.to_i	
				elsif key == "email"
						newhash[key] = {$nq => null}
				end
				#newhash[key.to_s] = hash.delete(key)
			end
			puts "newhash:#{newhash}"
			newhash
		end

	end
end