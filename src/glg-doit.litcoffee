#glg-doit
An embeddable task list.

    _ = require 'lodash'
    Polymer 'glg-doit',

##Events

##Attributes and Change Handlers
###taskview
This is the name of the view currently selected.


##Methods
###todoNumber
All about formatting the number of todos, which really means defaulting.

      todoNumber: (value) ->
        value or 0

##Event Handlers

      taskComplete: (evt, task) ->
        your = _.remove @data.your, (x) -> x is task
        delegated = _.remove @data.delegated, (x) -> x is task
        _.flatten([your, delegated]).forEach (task) =>
          @data.complete.push task

      taskIncomplete: (evt, task) ->
        complete = _.remove @data.complete, (x) -> x is task
        complete.forEach (task) =>
          if task?.who?.length
            @data.delegated.push task
          else
            @data.your.push task

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
