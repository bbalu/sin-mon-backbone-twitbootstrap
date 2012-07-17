//
// I have used Jasmine 1.2.0 standalone project
// Ref: Backbone fundamentals book by Addy osmani
describe('Tests for Feedbacks-prototype', function() {

	it('Can be created with default values for its attributes.', function() {
		var feedback = new app.Feedback();
		expect(feedback.get('comments')).toBe("");
	});	

	it('Will set passed attributes on the model instance when created.', function() {
		var feedback = new app.Feedback({ comments: 'I provided comments from specrunner.' });
		// what are the values expected here for each of the
		// attributes in our Todo?
		expect(feedback.get('rating')).toBe(5);
		expect(feedback.get('priority')).toBe(0);
		expect(feedback.get('email')).toBe("");
		expect(feedback.get('comments')).toBe("I provided comments from specrunner.");
		expect(feedback.get('newsletter')).toBe(true);
		expect(feedback.get('completed')).toBe(false);
		expect(feedback.get('status')).toBe("not assigned");
	});

	it('Fires a custom event when the state changes.', function() {
		var spy = jasmine.createSpy('-change event callback-');	
		var feedback = new app.Feedback();

		feedback.on('change', spy);

		feedback.set({ rating: 2 });

		expect(spy).toHaveBeenCalled();
	});

	it('Can contain custom validation rules, and will trigger an error event on failed validation.', 
			function() {
			
			var errorCallback = jasmine.createSpy('-error event callback-');	
			var feedback = new app.Feedback();
			feedback.on('error', errorCallback);
			feedback.set({completed: 'false'});

			var errorArgs = errorCallback.mostRecentCall.args;

			expect(errorArgs).toBeDefined();
			expect(errorArgs[0]).toBe(feedback);
			expect(errorArgs[1]).toBe('Feedback.completed must be a boolean value.');
	});
});

//
// collections test suite
//
describe('Tests for Feedbacks-collection', function() {

	it('Can add Model instances as objects and arrays.', function() {
		var feedbacks = new app.Feedbacks();	

		feedbacks.add({ comments: 'I added comments from collection test suite' });

		expect(feedbacks.length).toBe(1);

		feedbacks.add([
			{ comments: 'comments 1', completed: true },
			{ comments: 'comments 2'}
		]);		

		expect(feedbacks.length).toBe(3);
	});


	it('Can have a url property to define the basic url structure for all contained models.', function() {
		var feedbacks = new app.Feedbacks();

		expect(feedbacks.url).toBe('/api/v1/feedbacks');
});	
});

