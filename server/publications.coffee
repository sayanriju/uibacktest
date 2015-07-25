Meteor.publish "objectsFromFactory", (args) ->
  # Meteor._sleepForMs 5000
  return objectFactory.find({}, {fields: {}})
