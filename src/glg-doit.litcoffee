#glg-doit
*TODO* tell me all about your element.

    moment = require 'moment'
    Polymer 'glg-doit',

##Events
*TODO* describe the custom event `name` and `detail` that are fired.

##Attributes and Change Handlers
###taskview
This is the name of the view currently selected.

###coworkers
Current search result of your coworkers.

##Methods
###relativeDat
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
        console.log query
        @$.coworkers.body = JSON.stringify
          query:
            match:
              name: query.value
        @$.coworkers.go()

##Event Handlers

      coworkersResponse: (evt, detail)->
        @coworkers = detail?.response?.hits?.hits?.map (result) -> result._source


##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->
        @taskview = 'your'

      domReady: ->

      detached: ->

      publish:
        taskview:
          reflect: true
