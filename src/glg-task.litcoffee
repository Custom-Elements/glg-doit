#glg-task
This is a single task UI.

    require '../node_modules/ui-styles/animations'

    rules = require './rules.litcoffee'
    Polymer 'glg-task',

##Events
###go-back
Navigate away.

###task-save
Fired when a task is in any way updated.

###task-delete
Fired when a task needs a trip to the shredder.

##Attributes and Change Handlers
###task

###coworkers
Current search result of your coworkers.

##Methods
###loginName
Pick the login name out of an autocomplete person.

      pluckUsername: (person) ->
        person?.username

      relativeDate: rules.relativeDate

      due: rules.due

###delegatedToMe
I've been asked to do this.

      delegatedToMe: (task) ->
        rules.delegatedToMe task, @username

###searchCoworkers
Search for coworkers to delegate. This will trigger an autocomplete style
search often, then present them for selection in the ui-typeahead via binding.

      searchCoworkers: (evt, query) ->
        console.log 'search', query
        @$.coworkers.body = JSON.stringify
          query:
            match:
              name: query?.value
        @$.coworkers.go()

##Event Handlers

      coworkersResponse: (evt, detail)->
        @coworkers = detail?.response?.hits?.hits?.map (result) -> result._source

      deleteTodo: ->
        @fadeOut =>
          @removeAttribute 'hidden'
          @fire 'task-delete', @task
          @fire 'go-back'

      saveTodo: (evt) ->
        evt.stopPropagation()
        @fire 'task-save', @task

      goBack: (evt) ->
        evt.stopPropagation()
        @fire 'go-back'

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
