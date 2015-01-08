#glg-doit
An embeddable task list.

    _ = require 'lodash'
    rules = require './rules.litcoffee'
    epiquery2 = require 'epiquery2'
    Polymer 'glg-doit',

##Events

##Attributes and Change Handlers
###taskview
This is the name of the view currently selected.

###username
Who am I? Once we know a user, kick off a query to get all your tasks.

      usernameChanged: ->
        @epiclient.query 'glglive_o', 'todo/list.mustache',
          username: @username

##Methods
###addTodo

      addTodo: ->
        @data.todo.unshift
          who: @username
          autofocus: true

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

A single buffer of objects is kept and updated, then managed in lists for
display.

The main thing is to move the task into the right view list, todo, delegated, done.

A task is todo if you made it, or it was delegated to you by someone else.

A task is delegated if you made it and delegated it to someone else.

Any done task is just that.

Any other task isn't your problem!


      processTask: (evt, task) ->
        console.log task
        rules.validate task, @username
        @data = @data or {}
        @data.todo = @data.todo or []
        @data.delegated = @data.delegated or []
        @data.done = @data.done or []
        @data.all = @data.all or {}

        task = _.extend @data.all[task.id] or {}, task

        if task.done
          _.remove @data.delegated, (x) -> x.guid is task.guid
          _.remove @data.todo, (x) -> x.guid is task.guid
          if not _.any(@data.done, (x) -> x.guid is task.guid)
            @data.done.push task
        else if rules.delegatedOut task, @username
          _.remove @data.todo, (x) -> x.guid is task.guid
          _.remove @data.done, (x) -> x.guid is task.guid
          if not _.any(@data.delegated, (x) -> x.guid is task.guid)
            @data.delegated.push task
        else if rules.forMe task, @username
          _.remove @data.delegated, (x) -> x.guid is task.guid
          _.remove @data.done, (x) -> x.guid is task.guid
          if not _.any(@data.todo, (x) -> x.guid is task.guid)
            @data.todo.push task
        else
          _.remove @data.todo, (x) -> x.guid is task.guid
          _.remove @data.delegated, (x) -> x.guid is task.guid
          _.remove @data.done, (x) -> x.guid is task.guid

###processTaskDelete
This one is a bit simpler than a normal update, just pull it from the lists.

      processTaskDelete: (evt, task) ->
        console.log 'delete', task
        delete @data.all[task.guid]
        _.remove @data.delegated, (x) -> x.guid is task.guid
        _.remove @data.todo, (x) -> x.guid is task.guid
        _.remove @data.done, (x) -> x.guid is task.guid
        @epiclient.query 'glglive_o', 'todo/deleteTask.mustache', task

###processTaskSave
To the database with you!

      processTaskSave: (evt, task) ->
        rules.validate task, @username
        console.log 'save', task
        @epiclient.query 'glglive_o', 'todo/addTask.mustache', task
        @processTask undefined, task

##Polymer Lifecycle

      created: ->

      ready: ->

Hooking up to epistream. Each row coming back gets processed the same from
the server as from the client.

      attached: ->
        @taskview = 'your'
        @epiclient = new epiquery2.EpiClient([
          "wss://services.glgresearch.com/epistream-consultations-clustered/sockjs/websocket"
          "wss://east.glgresearch.com/epistream-consultations-clustered/sockjs/websocket"
          "wss://west.glgresearch.com/epistream-consultations-clustered/sockjs/websocket"
          "wss://europe.glgresearch.com/epistream-consultations-clustered/sockjs/websocket"
          "wss://asia.glgresearch.com/epistream-consultations-clustered/sockjs/websocket"
          ]);
        @epiclient.on 'row', (row) =>
          @processTask undefined, row.columns
        @epiclient.on 'error', ->
          console.log arguments

      domReady: ->

      detached: ->

      publish:
        taskview:
          reflect: true
