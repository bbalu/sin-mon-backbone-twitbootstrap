class FeedbacksRouter extends Backbone.Router
	routes: 
		'': 'rootPage'
		'new': 'newPage'
		'lists': 'listsPage'
		
	initialize: ->
		console.log 'router initialize'

	rootPage: ->
		console.log 'rootPage called'
		@appView = new app.AppView collection: app.feedbacks
		app.feedbacks.fetch()		

		# summary pane is active by default
		@setActivePane 0

	setActivePane: (paneId) ->
		@appView.setActivePane paneId

	newPage: ->
		console.log 'new Feedbacks called'

	listsPage: ->
		console.log 'list Feedbacks called'

@app = window.app ? {}
@app.FeedbacksRouter = FeedbacksRouter

