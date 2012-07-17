#views.coffee
jQuery ->
	

	class FeedbackInputView extends Backbone.View
		el: "#newFeedback"
		template: _.template($('#feedbacks-input-tmpl').html())
		events: 
			"click #sendFeedback":  "sendFeedback"

		initialize: ->
			console.log 'FeedbackInputView.initialize'

		render: ->
			console.log 'FeedbackInputView.render'
			$(@el).empty()
			$(@el).html @template()
			@

		sendFeedback: (e) ->
			console.log "FeedbackInputView.sendFeedback::"	
			e.preventDefault()

			# create feedback model through the feedback collection
			@collection.create create_at: new Date, comments: $("#comments").val(), completed: true

	class FeedbackSummaryView extends Backbone.View
		el: "#summary"
		template: _.template($('#feedbacks-summary-tmpl').html())

		initialize: ->
			console.log 'FeedbackSummaryView.initialize'

		render: ->
			console.log 'FeedbackSummaryView.render'
			$(@el).empty()
			$(@el).html @template()
			@		
			
	class FeedbackListView extends Backbone.View
		el: "#lists"
		template: _.template($('#feedbacks-list-tmpl').html())
		events:
			#'click #prev': 'prevSliderClick'
			#'click #next': 'nextSliderClick'
			'click #sort-btn': 'sortby'

		sortby: (e) ->	
			console.log 'Sort Button clicked...........'
			e.preventDefault()
			#@collection.sortBy (feedback) -> 
			#						Math.sin(feedback.get("rating"))
			#@render

		prevSliderClick: (e) ->
			console.log 'FeedbackListView.prevSliderClick', window.mySwipe
			e.preventDefault()
			window.mySwipe.prev()
			return false

		nextSliderClick: (e) ->
			console.log 'FeedbackListView.nextSliderClick', window.mySwipe
			e.preventDefault()
			window.mySwipe.next()
			return false

		initialize: ->
			console.log 'FeedbackListView.initialize'
			@collection.on 'reset', @render, @
			@collection.on 'remove', @render, @

		render: ->
			console.log 'FeedbackListView.render'
			collection = @collection 
			console.log "collection.length", collection.length
			$(@el).empty()
			$(@el).html @template()
			if (collection.length)
				# add the swipe event
				#console.log 'swipe:', $('#slider')
				#console.log 'swipe:', window.mySwipe

				collection.each (feedback) ->
					view = new FeedBackListItemView collection:collection, model:feedback
					$("#feedback_list_ul").append view.render().el

				#window.mySwipe = new Swipe document.getElementById('slider', speed: 0)
				#window.mySwipe.speed = 0;
				#$("#feedback_list_ul").children(":first").css("display", "block")
				#window.mySwipe.slide(0, 1000)
			@

	class FeedBackListItemView extends Backbone.View
		tagName: "li"
		className: "well span4 item"
		template: _.template $("#feedback-list-item-tmpl").html()
		events:
			'swipe': 'swipeEvent'
			'click .icon-remove': 'removeList'
			'click #change-status': 'changeStatus'

		swipeEvent: ->
			console.log 'swipeEvent on the li. Horraaaaaaaaaaaaaaaaaaay!'

		initialize: ->
			#console.log "FeedBackListItemView.initialize::"

		render: ->
			#console.log "FeedBackListItemView.render::"	
			renderedContent = @template @model.toJSON()
			@$el.html renderedContent
			@

		removeList: (e) ->
			#console.log 'FeedBackListItemView.removeList', @collection, @model
			e.preventDefault()
			#@collection.remove @model
			#@model.destroy	success: ->
            #    					alert 'Wine deleted successfully'
                					#window.history.back();
        	#return false;
			@model.clear()

		changeStatus: (e) ->
			e.preventDefault()
			console.log 'FeedBackListItemView.changeStatus...'

	class FeedbackNavView extends Backbone.View
		#template: _.template($('#feedbacks-nav-tmpl').html())

		initialize: ->
			console.log 'FeedbackNavView.initialize'

		render: ->
			console.log 'FeedbackNavView.render'
			$(@el).html @template()
			@


	class AppView extends Backbone.View
		el: "#center_content"

		initialize: ->
			console.log 'AppView initialize'
			@collection.bind 'reset', @render, @
			@panes = [
				new FeedbackSummaryView collection: @collection
				new FeedbackListView collection: @collection
				new FeedbackInputView collection: @collection
			]

			@subviews = [
		        new FeedbackNavView		collection: @collection
		    ]

		render: ->	
			console.log 'AppView.render'
			#$(@el).empty()
			#$(@el).append subview.render().el for subview in @subviews
			#$(@el).append @activePane.render().el
			@

		setActivePane: (paneId) ->
			console.log 'setActivePane', paneId
			@panes[paneId].render().el
			#$(@el).append @activePane.render().el

	
	@app = window.app ? {}
	@app.AppView = AppView		  



