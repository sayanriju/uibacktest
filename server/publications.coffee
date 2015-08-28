Meteor.publish "objectsFromFactory", (args) ->
  # Meteor._sleepForMs 5000
  return objectFactory.find({}, {fields: {}})

Meteor.publish "myRules", (args) ->
  return rules.find({})
