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

###justMine
Task for me from me.

      justMine: (task) ->
        rules.justMine task, @username

###due
Style things with this filter.

      due: (at) ->
        if at < Date.now()
          "red"

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
          @fire 'task-delete', @task

      saveTodoIfEditing: (evt) ->
        evt.stopPropagation()
        if @$.preview.hasAttribute 'expanded'
          @fire 'task-save', @task

      doneTodo: (evt) ->
        evt.stopPropagation()
        @fire 'task-save', @task

###completeChange
Capture the change event on a check to allow for an animation, otherwise the
checked task would just flash out of existence.

##focus
Get down to the business of editing.

      focus: ->
        @$.preview.expand()
          
      focusEdit: ->
        @$.what.focus()


##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
