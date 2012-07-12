class Feedback extends Backbone.Model
	idAttribute: "_id"

	defaults: ->
		rating: 5
		status: "not assigned"
		priority: 0
		email: ""
		newsletter: true
		comments: ""
		completed: false	

	initialize: ->

	#TBD: override validate() method 
	clear: ->
		status = @destroy()
		console.log 'destroy status:', status
		
@app = window.app ? {}
@app.Feedback = Feedback


	