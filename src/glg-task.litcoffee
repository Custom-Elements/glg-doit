#glg-doit
This is a single task UI.

    moment = require 'moment'
    Polymer 'glg-task',

##Events
###complete
Fired when the task is complete.

###incomplete
Fired if you move the task back to not complete.

##Attributes and Change Handlers
###task

###coworkers
Current search result of your coworkers.

##Methods
###relativeDate
Display filter for dates. Modern styling.

      relativeDate: (value) ->
        if value
          moment(value).fromNow()
        else
          ""

###searchCoworkers
Search for coworkers to delegate. This will trigger an autocomplete style
search often, then present them for selection in the ui-typeahead via binding.

      searchCoworkers: (evt, query) ->
        @$.coworkers.body = JSON.stringify
          query:
            match:
              name: query.value
        @$.coworkers.go()

##Event Handlers

      coworkersResponse: (evt, detail)->
        @coworkers = detail?.response?.hits?.hits?.map (result) -> result._source

      completeChange: ->
        anim = @animate [
          {height: @clientHeight, opacity: 1, transform: 'translateX(0)', offset: 0}
          {height: @clientHeight, opacity: 0, transform: 'translateX(2%)', offset: 0.5}
          {height: 0, opacity: 0, transform: 'translateX(2%)', offset: 1}
        ], duration: 500, easing: "0.5s cubic-bezier(0.4, 0.0, 1, 1)"
        anim.onfinish = =>
          console.log 'complete change', @task, @task.complete
          if @task.complete
            @fire 'complete', @task
          else
            @fire 'incomplete', @task

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
