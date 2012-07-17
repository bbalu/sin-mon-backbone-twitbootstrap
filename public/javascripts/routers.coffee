class FeedbacksRouter extends Backbone.Router
	routes: 
		'': 'rootPage'
		'new': 'newPage'
		'lists': 'listsPage'
		
	initialize: ->
		console.log 'router initialize'
		
		@appView = new app.AppView collection: app.feedbacks

		# summary pane is active by default
		@setActivePane 0

	rootPage: ->
		console.log 'rootPage called'
		app.feedbacks.fetch()		

	setActivePane: (paneId) ->
		console.log 'PaneId:', paneId 
		@appView.setActivePane paneId

	newPage: ->
		console.log 'new Feedbacks called'

	listsPage: ->
		console.log 'list Feedbacks called'

@app = window.app ? {}
@app.FeedbacksRouter = FeedbacksRouter

