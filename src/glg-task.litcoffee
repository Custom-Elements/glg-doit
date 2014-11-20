#glg-doit
This is a single task UI.

    moment = require 'moment'
    Polymer 'glg-task',

##Events

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


##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
