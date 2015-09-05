Meteor.methods
  "addToQueue": (obj, ruleID) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    nodes = []
    for item in obj.localNodes
      delete item.ipPortsAvailable
      delete item.opPortsAvailable
      delete item.pos
      nodes.push item

    Queue.insert {
      ruleID: ruleID
      timestamp: Date.now() / 1000 | 0
      userId: Meteor.userId()
      nodes: nodes
      connections: obj.localEdges
      dataDesc: obj.localDataDesc
      prefs: obj.localPrefs
    }
