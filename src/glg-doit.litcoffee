#glg-doit
An embeddable task list.

    _ = require 'lodash'
    uuid = require 'node-uuid'
    Polymer 'glg-doit',

##Events

##Attributes and Change Handlers
###taskview
This is the name of the view currently selected.


##Methods
###testData
Fill me with piles of tasks simulating the event flow
from the server that does not exist yet.

      testData: ->
        @$.bus.fire 'task',
          what: "Finish me\n* Shiny\n* Happy\n"
          when: "11/25/14"
        @$.bus.fire 'task',
          what: "Start me"
          when: "11/25/17"
        @$.bus.fire 'task',
          delegated: "glgroup\\lsylvetsky"
          what: "Use some sockets\nto make some TPV"
          when: "12/21/14"
        @$.bus.fire 'task',
          delegated: "glgroup\\rloebl"
          what: "Make some slides"
          when: "12/21/14"
        @$.bus.fire 'task',
          delegated: "glgroup\\rloebl"
          what: "All the things!"
          when: "12/3/14"
          complete:
            who: "glgroup\\rloebl"
            when: "12/4/14"



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

      processTask: (evt, task) ->
        @data = @data or {}
        @data.todo = @data.todo or []
        @data.delegated = @data.delegated or []
        @data.done = @data.done or []
        task.id = uuid.v1() unless task.id
        if task.complete
          _.remove @data.delegated, (x) -> x.id is task.id
          _.remove @data.todo, (x) -> x.id is task.id
          @data.done.push task
        else
          if task.delegated
            _.remove @data.todo, (x) -> x.id is task.id
            _.remove @data.done, (x) -> x.id is task.id
            @data.delegated.push task
          else
            _.remove @data.delegated, (x) -> x.id is task.id
            _.remove @data.done, (x) -> x.id is task.id
            @data.todo.push task

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
