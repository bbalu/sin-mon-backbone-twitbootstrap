// Generated by CoffeeScript 1.3.3
(function() {
  var _ref;

  this.app = (_ref = window.app) != null ? _ref : {};

  jQuery(function() {
    var router, setupErrorHandlers;
    console.log('apps.coffee');
    $('#my-nav-tab').tab();
    console.log('slider:', $('#slider'));
    setupErrorHandlers = function() {
      return $(document).ajaxError(function(error, xhr, settings, exception) {
        var message, _ref1;
        console.log(xhr.status, xhr.responseText, "EXCEPTION: " + exception);
        message = xhr.status === 0 ? "The server could not be contacted." : xhr.status === 403 ? "Login is required for this action." : (500 <= (_ref1 = xhr.status) && _ref1 <= 600) ? "There was an error on the server." : void 0;
        return console.log(message);
      });
    };
    setupErrorHandlers();
    router = new app.FeedbacksRouter;
    $('#my-nav-tab').on('show', function(e) {
      var contentID, pattern;
      pattern = /#.+/gi;
      contentID = e.target.toString().match(pattern)[0];
      $('#my-nav-tab').tab();
      console.log('tab event occured', pattern, contentID);
      if (contentID === '#summary') {
        router.setActivePane(0);
      } else if (contentID === '#lists') {
        router.setActivePane(1);
      } else if (contentID === '#newFeedback') {
        router.setActivePane(2);
      }
    });
    return Backbone.history.start({
      pushState: true
    });
  });

}).call(this);
