	class PaginatedListItemView extends Backbone.View
		tagName: 'li'
		template: _.template $('#resultItemTemplate').html()

		initialize: ->
			@model.bind 'change', @render, @
			@model.bind 'destroy', @render, @
		
		render: ->
			@.$el.html(@template(@model.to_json()));
			@	

	class PaginatedBottomView extends Backbone.View
		tagName: 'aside'
		template: _.template $('#tmpServerPagination').html()

		initialize: ->
			console.log 'PaginatedBottomView.initialize'
			@collection.on 'reset', @render, @
			@collection.on 'change',@render, @		
			@$el.appendTo '#pagination'

		render: ->
			console.log 'PaginatedBottomView.render'
			html = @template	@collection.info()
			@$el.html html
			@

	class PaginatedListView extends Backbone.View
		el: '#content'
		initialize: ->
			console.log 'PaginatedListView.initialize'			
			feedbacks = @collection
			feedbacks.on 'add', @addOne, @
			feedbacks.on 'reset', @addAll, @
			feedbacks.on 'all', @render, @

			feedbacks.pager()

		addAll : ->
			console.log 'PaginatedListView.addAll'			

			@$el.empty();
			@collection.each (@addOne);
		
		addOne : ( feedback ) ->
			console.log 'PaginatedListView.addOne'			

			view = new views.PaginatedListItemView({model:feedback});
			$('#content').append(view.render().el);

		render: ->
			return

	class PaginatedAppView extends Backbone.View
		el: "#lists"
		template: _.template($('#feedbacks-list-tmpl').html())

		initialize: ->
			console.log 'PaginatedAppView.initialize'
			new PaginatedListView collection:app.feedbackspaginated
			new PaginatedBottomView collection:app.feedbackspaginated

		render: ->
			console.log 'PaginatedAppView.render'			
			@$el.empty()
			@$el.html @template()
			@
