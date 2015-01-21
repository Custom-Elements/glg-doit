#glg-doit-preview
This is a single task UI in preview -- not edit -- mode

    moment = require 'moment'
    rules = require './rules.litcoffee'
    Polymer 'glg-task-preview',

##Events
###task-save
Fired when a task is in any way updated.

###task-edit
Time to get the UI to switch into an edit for a specific task.

##Attributes and Change Handlers
###task

##Methods

      relativeDate: rules.relativeDate

      due: rules.due

###delegatedOut
Asking someone else to do this.

      delegatedOut: (task) ->
        rules.delegatedOut task, @username

###delegatedToMe
I've been asked to do this.

      delegatedToMe: (task) ->
        rules.delegatedToMe task, @username

###justMine
Task for me from me.

      justMine: (task) ->
        rules.justMine task, @username

##Event Handlers

      doneTodo: (evt) ->
        evt.stopPropagation()
        @fire 'task-save', @task

      editTodo: (evt) ->
        evt.stopPropagation()
        @fire 'task-edit', @task

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
