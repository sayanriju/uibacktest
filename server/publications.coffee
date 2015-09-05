Meteor.publish "objectsFromFactory", (args) ->
  # Meteor._sleepForMs 5000
  return objectFactory.find({}, {fields: {}})

Meteor.publish "myRules", (args) ->
  return Rules.find({userId: @userId})

Meteor.publish "myQueue", (args) ->
  return Queue.find({userId: @userId})

Meteor.publish "hasResult", (ruleID) ->
  return Results.find({ruleID: ruleID}, {fields: {ruleID: 1}})

Meteor.publish "getResult", (ruleID) ->
  return Results.find({ruleID: ruleID})
