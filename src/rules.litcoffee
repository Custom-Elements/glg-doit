These are the data processing rules as functions.

    uuid = require 'node-uuid'
    moment = require 'moment'

    module.exports = rules =

###validate
Make sure the task data can be saved or displayed.

      validate: (task, me) ->
        task.guid = uuid.v1() unless task.guid
        task.who = me unless task.who
        task.what = task.what or ''
        if task.when
          task.when = moment(task.when).utc().format("YYYY-MM-DD")
        else
          task.when = null
        task.delegate = task.delegate or ''

###delegatedOut
Asking someone else to do this.

      delegatedOut: (task, me) ->
        task?.who is me and task?.delegate

###delegatedToMe
I've been asked to do thi.

      delegatedToMe: (task, me) ->
        task?.who isnt me and task?.delegate is me

###forMe
All tasks that I need to follow.

      forMe: (task, me) ->
        rules.delegatedToMe(task, me) or (task?.who is me and not task?.delegate)
