#glg-doit
An embeddable task list.

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
