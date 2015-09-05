Meteor.publish "objectsFromFactory", (args) ->
  # Meteor._sleepForMs 5000
  return objectFactory.find({}, {fields: {}})

Meteor.publish "myRules", (args) ->
  return Rules.find({})

Meteor.publish "theQueue", (args) ->
  return Queue.find({})

Meteor.publish "myResults", (args) ->
  myRules = Rules.find({}, {fields: {_id: 1}}).fetch()
  return Results.find({ruleID: {$in: myRules}})
