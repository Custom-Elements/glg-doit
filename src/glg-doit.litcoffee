#glg-doit
An embeddable task list.

    _ = require 'lodash'
    rules = require './rules.litcoffee'
    epiquery2 = require 'epiquery2'
    hummingbird = require 'hummingbird'
    Polymer 'glg-doit',

##Events

##Attributes and Change Handlers
###searchstring
What we are looking for now. This is data bound driven.

      searchstringChanged: ->
        @search()

###taskview
This is the name of the view currently selected.

      taskviewChanged: ->
        @updateView()

###username
Who am I? Once we know a user, kick off a query to get all your tasks.

      usernameChanged: ->
        @epiclient.query 'glglive_o', 'todo/list.mustache',
          username: @username
        @epiclient.query 'glglive_o', 'todo/doneList.mustache',
          username: @username
        clearInterval @updatePoll
        @updatePoll = setInterval =>
          if @next_baseline
            @epiclient.query 'glglive_o', 'todo/listChanges.mustache',
              username: @username
              next_baseline: @next_baseline
            , 'poll'
        , 1000

##Methods
###addTodo
Adding a todo will check for a 'your' task that is blank to avoid a long
string of blank tasks. Otherwise -- it just pushes a new task on the list.

This has a one time event handler to make sure we are on the 'your' tab
to allow data entry.

      addTodo: ->
        focusOnBlankElement = =>
          taskElements = @shadowRoot.querySelectorAll('glg-task').array()
          for taskElement in taskElements
            if not taskElement.templateInstance.model.task.what and not taskElement.hasAttribute('hidden')
              taskElement.focus()
              return true
          false
        if not focusOnBlankElement()
          @data.unshift
            who: @username
          @async focusOnBlankElement


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
        console.log 'processing', task
        @next_baseline = task.next_baseline or @next_baseline
        rules.validate task, @username

        existingTask = @data.filter (t) =>
          task.guid is t.guid

        if existingTask[0]
          task = _.extend existingTask[0], task
        else
          @data.push task

        @updateView()

      updateView: ->
        @data.your = 0
        @data.completed = 0
        @data.delegated = 0
        @data.forEach (task) =>
          task.filtered = false
          if task.done
            @data.completed++
            task.filtered = true unless @taskview is "complete"
          else
            if rules.forMe task, @username
              @data.your++
              task.filtered = true unless @taskview is "your"
            else if rules.delegatedOut task, @username
              @data.delegated++
              task.filtered = true unless @taskview is "delegated"


###processTaskDelete
This one is a bit simpler than a normal update, just pull it from the lists.

      processTaskDelete: (evt, task) ->
        console.log 'delete', task
        _.remove @data, task
        @epiclient.query 'glglive_o', 'todo/deleteTask.mustache', task

###processTaskSave
To the database with you!

      processTaskSave: (evt, task) ->
        rules.validate task, @username
        @job task.guid, =>
          console.log 'save', task
          @epiclient.query 'glglive_o', 'todo/addTask.mustache', task
          @processTask undefined, task


###processTaskEdit
Edit a single task record.

      processTaskEdit: (evt, task) ->
        console.log task
        @editTask = task
        @async ->
         @$.navigation.push @$.taskedit

###search
Process a search, this will:
* make sure there is a current index, leveraging the `@next_revision` from SQL
* search the index for an array of tasks
* swap the UI out with a data bound list or search results

      search: (evt) ->
        if (@index?.at_revision or 0) isnt @next_baseline
          @index = new hummingbird.Index()
          @index.at_revision = @next_baseline or 0
          @data.forEach (task) =>
            @index.add
              id: task.guid
              name: "#{task.what} #{task.who}"
              task: task
        if @$.search.value?.trim()
          @index.search @$.search.value, (results) =>
            @data.search = results.map (x) -> x.task
            @taskview = 'search'
        else
          @data.search = []
          @taskview = 'your'

##Polymer Lifecycle

      created: ->
        @data = []

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
