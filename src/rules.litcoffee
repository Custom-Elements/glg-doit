These are the data processing rules as functions.

    uuid = require 'node-uuid'
    moment = require 'moment'

    module.exports = rules =

###validate
Make sure the task data can be saved or displayed.

      validate: (task, me) ->
        task.guid = uuid.v1() unless task.guid
        task.who = me unless task.who
        if task.when
          task.when = moment(task.when).utc().format("YYYY-MM-DD")

###delegatedOut
Asking someone else to do this.

      delegatedOut: (task, me) ->
        task?.who is me and task?.delegated

###delegatedToMe
I've been asked to do thi.

      delegatedToMe: (task, me) ->
        task?.who isnt me and task?.delegated is me

###forMe
All tasks that I need to follow.

      forMe: (task, me) ->
        rules.delegatedToMe(task, me) or (task?.who is me and not task?.delegated)
