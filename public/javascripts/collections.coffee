class Feedbacks extends Backbone.Collection
	model: app.Feedback
	url: '/api/v1/feedbacks'
	
	#localStorage: new Store "feedbacks-vid"
	initialize: ->
		console.log "Feedbacks collection initialize called"
		@bind 'remove'

	completed: ->
		console.log "Feedbacks.completed::"
		@filter( (feedback)-> return feedback.get('completed') )

	leads: ->
		console.log "Feedbacks.leads::"
		@filter( (feedback)-> return ( feedback.get('email') || feedback.get('newsletter') ) )

@app = window.app ? {}
@app.feedbacks = new Feedbacks