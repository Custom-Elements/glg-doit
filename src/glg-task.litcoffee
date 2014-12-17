#glg-doit
This is a single task UI.

    moment = require 'moment'
    _ = require 'lodash'
    require '../node_modules/ui-styles/animations'

    rules = require './rules.litcoffee'
    Polymer 'glg-task',

##Events
###task
Fired when a task is in any way updated.

###task-delete
Fired when a task needs a trip to the shredder.

##Attributes and Change Handlers
###task

      taskChanged: ->
        if @task.autofocus
          delete @task.autofocus
          @async =>
            @startEditing()

###coworkers
Current search result of your coworkers.

##Methods
###loginName
Pick the login name out of an autocomplete person.

      pluckUsername: (person) ->
        person?.username

###relativeDate
Display filter for dates. Modern styling.

      relativeDate: (value) ->
        if value
          moment(value?.toUTCString?() or value).fromNow()
        else
          ""

###delegatedOut
Asking someone else to do this.

      delegatedOut: (task) ->
        rules.delegatedOut task, @username

###delegatedToMe
I've been asked to do thi.

      delegatedToMe: (task) ->
        rules.delegatedToMe task, @username

###due
Style things with this filter.

      due: (at) ->
        if at < Date.now()
          "red"

###searchCoworkers
Search for coworkers to delegate. This will trigger an autocomplete style
search often, then present them for selection in the ui-typeahead via binding.

      searchCoworkers: (evt, query) ->
        @$.coworkers.body = JSON.stringify
          query:
            match:
              name: query.value
        @$.coworkers.go()

###save
Save a task and make sure things go well!

      save: ->
        console.log 'saving', @task
        rules.validate @task, @username
        @$.addTask.params = @task
        #@$.addTask.go()
        @fire 'task', @task

##Event Handlers

      coworkersResponse: (evt, detail)->
        @coworkers = detail?.response?.hits?.hits?.map (result) -> result._source

      addTaskResponse: (evt, detail) ->
        console.log 'task back from server', arguments

      addTaskError: (evt, detail) ->
        console.log 'error back from server', arguments

      deleteTodo: ->
        @fadeOut =>
          @fire 'task-delete', @task

###completeChange
Capture the change event on a check to allow for an animation, otherwise the
checked task would just flash out of existence.

      moveBetweenViews: (evt) ->
        evt.stopPropagation()
        @fadeOut =>
          @save()

      startEditing: ->
        @$.preview.expand =>
          @$.what.focus()

      taskUpdate: (evt, task) ->
        evt.stopPropagation()
        @save()

##Polymer Lifecycle

      created: ->

      ready: ->

Debounce the save, otherwise it gets a little fiesty as you type.

      attached: ->
        @save = _.debounce @save.bind(@), 1000

      domReady: ->

      detached: ->
