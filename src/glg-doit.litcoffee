#glg-doit
An embeddable task list.

    _ = require 'lodash'
    uuid = require 'node-uuid'
    rules = require './rules.litcoffee'
    Polymer 'glg-doit',

##Events

##Attributes and Change Handlers
###taskview
This is the name of the view currently selected.


##Methods
###addTodo

      addTodo: ->
        @data.todo.unshift
          who: @username
          autofocus: true

###testData
Fill me with piles of tasks simulating the event flow
from the server that does not exist yet.

      testData: ->
        @$.bus.fire 'task',
          who: @username
          what: "Finish me\n* Shiny\n* Happy\n"
          when: "11/25/14"
        @$.bus.fire 'task',
          who: @username
          what: "Start me"
          when: "11/25/17"
        @$.bus.fire 'task',
          who: @username
          delegated: "glgroup\\lsylvetsky"
          what: "Use some sockets\nto make some TPV"
          when: "12/21/14"
        @$.bus.fire 'task',
          who: @username
          delegated: "glgroup\\rloebl"
          what: "Make some slides"
          when: "12/21/14"
        @$.bus.fire 'task',
          who: "glgroup\\rloebl"
          delegated: @username
          what: "You make some slides"
          when: "12/21/14"
        @$.bus.fire 'task',
          who: @username
          delegated: "glgroup\\rloebl"
          what: "All the things!"
          when: "12/3/14"
          done: true

###todoNumber
All about formatting the number of todos, which really means defaulting.

      todoNumber: (value) ->
        value or 0

##Event Handlers
###processTask
Process any update to a task. No distinction is made from a local task change
or a remote one coming in from the server. So, changes or edits fire off a
`task` event locally, which is shuffled out to the server. Count on the server
to de-dupe and prevent a task event from ping-pong looping.

The main thing is to move the task into the right view list, todo, delegated, done.

A task is todo if you made it, or it was delegated to you by someone else.

A task is delegated if you made it and delegated it to someone else.

Any done task is just that.

Any other task isn't your problem!


      processTask: (evt, task) ->
        @data = @data or {}
        @data.todo = @data.todo or []
        @data.delegated = @data.delegated or []
        @data.done = @data.done or []
        task.id = uuid.v1() unless task.id
        if task.done
          _.remove @data.delegated, (x) -> x.id is task.id
          _.remove @data.todo, (x) -> x.id is task.id
          if not _.any(@data.done, (x) -> x.id is task.id)
            @data.done.push task
        else if rules.delegatedOut task, @username
          _.remove @data.todo, (x) -> x.id is task.id
          _.remove @data.done, (x) -> x.id is task.id
          if not _.any(@data.delegated, (x) -> x.id is task.id)
            @data.delegated.push task
        else if rules.forMe task, @username
          _.remove @data.delegated, (x) -> x.id is task.id
          _.remove @data.done, (x) -> x.id is task.id
          if not _.any(@data.todo, (x) -> x.id is task.id)
            @data.todo.push task
        else
          _.remove @data.todo, (x) -> x.id is task.id
          _.remove @data.delegated, (x) -> x.id is task.id
          _.remove @data.done, (x) -> x.id is task.id

###processTaskDelete
This one is a bit simpler than a normal update, just pull it from the lists.

      processTaskDelete: (evt, task) ->
        _.remove @data.delegated, (x) -> x.id is task.id
        _.remove @data.todo, (x) -> x.id is task.id
        _.remove @data.done, (x) -> x.id is task.id

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
