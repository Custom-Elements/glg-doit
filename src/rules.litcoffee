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

The done is just a check box, so make sure it is a date.

        if task.done
          if moment(task.done).isValid()
            task.done = moment(task.done).utc().toISOString()
          else
           task.done = moment().utc().toISOString()



###delegatedOut
Asking someone else to do this.

      delegatedOut: (task, me) ->
        task?.delegate?.length and task?.delegate?.toLowerCase() isnt me?.toLowerCase() and task?.who?.toLowerCase()is me?.toLowerCase()

###delegatedToMe
I've been asked to do this.

      delegatedToMe: (task, me) ->
        task?.who?.toLowerCase() isnt me?.toLowerCase() and task?.delegate is me?.toLowerCase()

###justMine
I've been asked to do this -- by MYSELF!

      justMine: (task, me) ->
        task?.who?.toLowerCase() is me?.toLowerCase() and not task?.delegate

###forMe
All tasks that I need to follow.

      forMe: (task, me) ->
        rules.delegatedToMe(task, me) or rules.justMine(task, me)

###relativeDate
Display filter for dates. Modern styling.

      relativeDate: (value) ->
        if value
          moment(value?.toUTCString?() or value).fromNow()
        else
          ""

###due
Style things with this filter.

      due: (at) ->
        if at < Date.now()
          "red"
