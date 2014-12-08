These are the data processing rules as functions.


    module.exports = rules =

###delegatedOut
Asking someone else to do this.

      delegatedOut: (task, me) ->
        task.who is me and task.delegated

###delegatedToMe
I've been asked to do thi.

      delegatedToMe: (task, me) ->
        task.who isnt me and task.delegated is me


###forMe
All tasks that I need to follow.

      forMe: (task, me) ->
        rules.delegatedToMe(task, me) or (task.who is me and not task.delegated)
