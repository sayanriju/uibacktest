Meteor.publish "objectsFromFactory", (args) ->
  # Meteor._sleepForMs 5000
  return objectFactory.find({}, {fields: {}})

Meteor.publish "myRules", (args) ->
  return Rules.find({})

Meteor.publish "theQueue", (args) ->
  return Queue.find({})
