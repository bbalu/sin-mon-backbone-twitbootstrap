#Fake data generator
require 'random_data'
require 'open-uri'
require 'json'
require './Feedbacks'

class FakeDataGenerator

	def initialize()
		Feedbacks.connect( {:server => 'localhost', :db => 'test'})	
	end

	def getByCityName()
		cities = ["mumbai", "chennai", "jaipur", "calcutta", "chandigarh", "delhi", "bhopal",
			"bangalore", "calicut", "trivandrum", "tiruvanandpuram", "hubli",
			"dharwad", "simla", "lucknow", "hyderabad", "patna",
			"ahmedabad", "darjeeling", "dehradun", "vijayawada", "vizag", 
			"tiruchi", "madurai", "siliguri",
			"goa", "coimbatore", "salem", "palakkad"]		
		puts cities.size
		cityId = Random.number(0..cities.size-1)
		
		city = cities[cityId]
		puts "selected city: #{city} #{cityId}"
		url = 'http://api.geonames.org/searchJSON?q='
		url += "#{city}&maxRows=1&style=LONG&lang=en&country=IN&username=bbalu"
		buffer = open(url, "UserAgent" => "Ruby-Wget").read

		# convert JSON data into a hash
		result = JSON.parse(buffer)

		if (result && result['totalResultsCount'] != 0)
			geonames = result['geonames']
			return {:lat => geonames[0]['lat'], 
				    :lng => geonames[0]['lng']
				    } 
		end
		{}
	end

	def getGeoName(lat, lng)

		url = "http://api.geonames.org/findNearbyJSON?"
		url += "lat=#{lat}"
		url += "&lng=#{lng}"
		url += "&username=bbalu"
		puts url

		buffer = open(url, "UserAgent" => "Ruby-Wget").read

		# convert JSON data into a hash
		result = JSON.parse(buffer)

		puts result
	end

	def genGeoSpatialCoordinates 
		#india geospatial coordinates
		# Bangalore coordinates: 12.985824,77.595062
		# source: http://www.mapsofindia.com/lat_long/
		# India range1 10..26N,72..88E 
		# India range2 26..30N,74..80E  

		#user's GPS is off, use IP address
		# http://stackoverflow.com/questions/2472850/is-geocoding-possible-with-a-phone-thats-not-gps-enabled

		# algorithm based on this discussion
		# http://gis.stackexchange.com/questions/25877/how-to-generate-random-locations-nearby-my-location
		#

		# step 1: generate random long, latitude with in India range1, range2
		# 
		#srand 1234
		coord = {}
		@range1_2 = Random.number(1..2)
		if @range1_2 == 1
		      coord[:lng] = Random.number(72..88) + rand # latitude
		      coord[:lat] = Random.number(10..26) + rand # longitude
		else 
			if @range1_2 == 2
		      coord[:lng] = Random.number(74..80) + rand
		      coord[:lat] = Random.number(26..30) + rand
		    end
		end
		coord

		# step 2: generate random radius within the step1 location

		# 	input # r in degrees, y0 in degrees, x0 in degrees
		#  
		# 	u = rand # gen float between 0..1
		# 	v = rand # gen float between 0..1 

		# 	w = r * Math.sqrt(u)
		# 	t = 2 * Math.PI * v
		# 	x = w * Math.cos(t)
		# 	y = w * Math.sin(t)
		# 	x' = x / Math.cos (y0)
		# 	random point = (x'+ x0, y + y0)
		#

	end
	def generate_data
		newHash = {}

		# http://strfti.me/ - create time with time zone
		#date = # create date 
		
		#sDateTime = Random.date(-60..-30).to_s + " " + Random.number(00..23).to_s + 
		#					":" + Random.number(00..59).to_s
		#dateTime = DateTime.parse(sDateTime, "%Y-%m-%d %T:%M")
		dateTime = Time.utc(Random.number(2008..2012),Random.number(1..12), 
					Random.number(1..28),
					Random.number(00..23), 
					Random.number(00..59), 
					Random.number(00..59))
		#puts dateTime.to_s

		isEmail = 0
		isEmail = Random.number(1..100)
		puts "isEmail: #{isEmail}"
		if isEmail.between?(80, 90)
			email = Random.email()
		else 
			email = ""
		end

		newHash = { :rating => Random.number(6),
					:newsletter => Random.boolean(),
		  			:create_at => dateTime,
		  			:comments => Random.paragraphs(2),
		  			:email =>  email, 
		  			:location => self.getByCityName
		  		}
		puts newHash  		
		Feedbacks.save(newHash)
	end

	def displayData
		feedbacks = Feedbacks.find :all
		if (feedbacks)
			feedbacks.each do |feedback|
				puts feedback
			end
		else
			puts "no feedbacks"
		end
	end
end

puts 'starting the app'
f = FakeDataGenerator.new()
100.times { f.generate_data }

#10.times do 
#	coord = f.genGeoSpatialCoordinates
#	#f.getGeoName(coord[:lat], coord[:lng])
#
#end 





