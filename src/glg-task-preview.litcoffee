#glg-doit-preview
This is a single task UI in preview -- not edit -- mode

    moment = require 'moment'
    rules = require './rules.litcoffee'
    Polymer 'glg-task-preview',

##Events
###task
Fired when a task is in any way updated.

##Attributes and Change Handlers
###task
h result of your coworkers.

##Methods

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

##Event Handlers

      doneTodo: (evt) ->
        evt.stopPropagation()
        @fire 'task-save', @task

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
