@app = window.app ? {}

jQuery ->
      console.log 'apps.coffee'

      $('#my-nav-tab').tab()
          

      console.log 'slider:', $('#slider')    

      setupErrorHandlers = ->
          $(document).ajaxError (error, xhr, settings, exception) ->
              # NOTE: Status will be 0 if the server is unreachable.
              console.log xhr.status, xhr.responseText, "EXCEPTION: " + exception
              message = if xhr.status == 0
                              "The server could not be contacted."
                      else if xhr.status == 403
                              "Login is required for this action."
                      else if 500 <= xhr.status <= 600
                              "There was an error on the server."
              console.log message

      setupErrorHandlers()
      router = new app.FeedbacksRouter
      
      $('#my-nav-tab').on 'show', (e) ->
          pattern = /#.+/gi #use regex to get anchor(==selector)
          contentID = e.target.toString().match(pattern)[0] #get anchor 
          $('#my-nav-tab').tab()
          console.log 'tab event occured', pattern, contentID
          if (contentID == '#summary')
              router.setActivePane 0 
          else if (contentID == '#lists')
              router.setActivePane 1
          else if (contentID == '#newFeedback')
              router.setActivePane 2
          return
      
      Backbone.history.start pushState : true